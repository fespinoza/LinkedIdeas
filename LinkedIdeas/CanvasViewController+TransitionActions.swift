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
    switch element {
    case let link as Link:
      document.remove(link: link)
    case let concept as Concept:
      delete(concept: concept)
    default:
      break
    }
  }

  func delete(elements: [Element]) {
    for element in elements {
      guard let concept = element as? Concept else {
        continue
      }
      delete(concept: concept)
    }
  }

  func delete(concept: Concept) {
    let linksToRemove = document.links.filter { $0.doesBelongTo(concept: concept) }
    for link in linksToRemove {
      document.remove(link: link)
    }
    document.remove(concept: concept)
  }

  func saveConcept(text: NSAttributedString, atPoint point: NSPoint) -> Concept? {
    guard text.string != "" else {
      return nil
    }

    let newConcept = Concept(attributedStringValue: text, point: point)

    document.save(concept: newConcept)

    return newConcept
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

  func showTextField(inRect rect: NSRect, text: NSAttributedString? = nil) {
    textFieldResizingBehavior.setFrame(toTextField: textField, forContentRect: rect)
    textField.isEditable = true
    textField.isHidden = false
    if let text = text {
      textField.attributedStringValue = text
      textFieldResizingBehavior.resize(textField)
    }
    canvasView.window?.makeFirstResponder(textField)
  }

  func showTextField(atPoint point: NSPoint, text: NSAttributedString? = nil) {
    textField.frame = NSRect(center: point, size: NSSize(width: 60, height: 25))
    textField.isEditable = true
    textField.isHidden = false
    if let text = text {
      textField.attributedStringValue = text
      textFieldResizingBehavior.resize(textField)
    }
    canvasView.window?.makeFirstResponder(textField)
  }

  func dismissTextField() {
    textField.setFrameOrigin(NSPoint.zero)
    textField.isEditable = false
    textField.isHidden = true
    textField.stringValue = ""

    canvasView.window?.makeFirstResponder(canvasView)
  }
}
