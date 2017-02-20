//
//  CanvasViewController+TransitionActions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

// MARK: - CanvasViewController+TransitionActions

extension CanvasViewController {
  func select(elements: [Element]) {
    for var element in elements { element.isSelected = true }
  }

  func unselect(elements: [Element]) {
    for var element in elements { element.isSelected = false }
  }

  func delete(element: Element) {
    if let link = element as? Link {
      document.remove(link: link)
    }

    if let concept = element as? Concept {
      document.remove(concept: concept)
    }
  }

  func delete(elements: [Element]) {
    for element in elements {
      guard let concept = element as? Concept else {
        continue
      }
      let linksToRemove = document.links.filter { $0.doesBelongTo(concept: concept) }
      for link in linksToRemove {
        document.remove(link: link)
      }
      document.remove(concept: concept)
    }
  }

  func saveConcept(text: NSAttributedString, atPoint point: NSPoint) -> Bool {
    guard text.string != "" else {
      return false
    }

    let newConcept = Concept(attributedStringValue: text, point: point)

    document.save(concept: newConcept)
    return true
  }

  func saveLink(fromConcept: Concept, toConcept: Concept, text: NSAttributedString? = nil) -> Link {
    var linkText = NSAttributedString(string: "")
    if let text = text {
      linkText = text
    }

    let newLink = Link(origin: fromConcept, target: toConcept, attributedStringValue: linkText)

    document.save(link: newLink)

    return newLink
  }

  func showTextField(atPoint point: NSPoint, text: NSAttributedString? = nil) {
    textField.frame = NSRect(center: point, size: NSSize(width: 60, height: 40))
    textField.isEditable = true
    textField.isHidden = false
    if let text = text { textField.attributedStringValue = text }
    textField.becomeFirstResponder()
  }

  func dismissTextField() {
    textField.setFrameOrigin(NSPoint.zero)
    textField.isEditable = false
    textField.isHidden = true
    textField.stringValue = ""

    canvasView.window?.makeFirstResponder(canvasView)
  }
}
