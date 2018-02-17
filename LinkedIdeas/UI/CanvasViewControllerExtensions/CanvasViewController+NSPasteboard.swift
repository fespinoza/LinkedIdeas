//
//  CanvasViewController+NSPasteboard.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 23/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

extension CanvasViewController {
  // MARK: - Pasteboard

  fileprivate func writeToPasteboard(pasteboard: NSPasteboard) {
    guard let elements = selectedElements() else {
      return
    }

    pasteboard.clearContents()
    pasteboard.writeObjects(elements.map { $0.attributedStringValue })
  }

  fileprivate func readFromPasteboard(pasteboard: NSPasteboard) {
    let rawObjects = pasteboard.readObjects(
      forClasses: [NSAttributedString.self], options: [:]
    ) as? [NSAttributedString]

    guard let objects = rawObjects, objects.count != 0 else {
      return
    }

    pasteConcepts(fromAttributedStrings: objects)
  }

  fileprivate func readFromPasteboardAsPlainText(pasteboard: NSPasteboard) {
    let rawObjects = pasteboard.readObjects(forClasses: [NSString.self], options: [:]) as? [String]

    guard let objects = rawObjects, objects.count != 0 else {
      return
    }

    pasteConcepts(fromAttributedStrings: objects.map { NSAttributedString(string: $0) })
  }

  fileprivate func pasteConcepts(fromAttributedStrings attributedStrings: [NSAttributedString]) {
    safeTransiton {
      try stateManager.toCanvasWaiting()
    }

    var newConcepts = [Concept]()
    for (index, string) in attributedStrings.enumerated() {
      lastCopyIndex += 1
      let copyReferenceIndex = index + lastCopyIndex + 1
      if let concept = createConceptFromPasteboard(attributedString: string, index: copyReferenceIndex) {
        newConcepts.append(concept)
      }
    }

    guard newConcepts.count > 0 else {
      return
    }

    if newConcepts.count > 1 {
      safeTransiton {
        try stateManager.toMultipleSelectedElements(elements: newConcepts)
      }
    } else {
      safeTransiton {
        try stateManager.toSelectedElement(element: newConcepts.first!)
      }
    }
  }

  fileprivate func createConceptFromPasteboard(attributedString: NSAttributedString, index: Int) -> Concept? {
    let newConceptPadding: Int = 15
    let newPoint = CGPoint(
      x: CGFloat(200 + (newConceptPadding*index)),
      y: CGFloat(200 + (newConceptPadding*index))
    )
    return saveConcept(text: attributedString, atPoint: newPoint)
  }

  // MARK: - Interface actions

  @objc func cut(_ sender: Any?) {
    writeToPasteboard(pasteboard: NSPasteboard.general)
    if let elements = selectedElements() {
      safeTransiton {
        try stateManager.toCanvasWaiting(deletingElements: elements)
      }
    }
  }

  @objc func copy(_ sender: Any?) {
    writeToPasteboard(pasteboard: NSPasteboard.general)
  }

  @objc func paste(_ sender: Any?) {
    readFromPasteboard(pasteboard: NSPasteboard.general)
  }

  @objc func pasteAsPlainText(_ sender: Any?) {
    readFromPasteboardAsPlainText(pasteboard: NSPasteboard.general)
  }
}
