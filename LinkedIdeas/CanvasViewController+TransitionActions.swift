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

    let newConcept = Concept(attributedStringValue: text, centerPoint: point)

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

  func showTextView(inRect rect: NSRect, text: NSAttributedString? = nil) {
    textStorage.setAttributedString(text ?? NSAttributedString(string: ""))
    let textViewFrame = rect
    textView.frame = textViewFrame
    textView.sizeToFit()
    reCenterTextView(atPoint: rect.center)

    textView.isHidden = false
    textView.isEditable = true

    canvasView.window?.makeFirstResponder(textView)
  }

  func showTextView(atPoint point: NSPoint, text: NSAttributedString? = nil) {
    let textViewFrame = NSRect(center: point, size: NSSize(width: 60, height: 25))
    showTextView(inRect: textViewFrame, text: text)
  }

  func dismissTextView() {
    textStorage.setAttributedString(NSAttributedString(string: ""))
    textView.setFrameOrigin(NSPoint.zero)
    textView.isEditable = false
    textView.isHidden = true

    canvasView.window?.makeFirstResponder(canvasView)
  }

  func reCenterTextView(atPoint centerPoint: CGPoint) {
    textView.setFrameOrigin(
      NSPoint(
        x: centerPoint.x - textView.frame.width / 2,
        y: centerPoint.y - textView.frame.height / 2
      )
    )
  }
}
