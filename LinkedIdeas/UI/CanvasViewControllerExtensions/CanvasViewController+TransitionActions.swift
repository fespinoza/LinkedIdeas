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

  func saveConcept(text: NSAttributedString, atPoint point: CGPoint) -> Concept? {
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

  func showTextView(inRect rect: CGRect, text: NSAttributedString? = nil, constrainedSize: CGSize? = nil) {
    textStorage.setAttributedString(text ?? NSAttributedString(string: ""))
    let textViewFrame = rect

    func calculateMaxSize(forCenterPoint centerPoint: CGPoint) -> CGSize {
      let centerPointInScrollView = scrollView.convert(centerPoint, from: canvasView)

      let deltaX1 = centerPointInScrollView.x
      let deltaX2 = scrollView.visibleRect.width - centerPointInScrollView.x

      return CGSize(
        width: min(deltaX1, deltaX2) * 2,
        height: scrollView.visibleRect.height
      )
    }

    // the maxSize for the textView should be the max size allowed given
    // the centerPoint where the text view will be displayed and the visible
    // rect that is shown by the NSScrollView
    let maxSize = constrainedSize ?? calculateMaxSize(forCenterPoint: rect.center)
    print(maxSize.debugDescription)

    textContainer.size = maxSize
    textView.maxSize = maxSize
    textView.frame = textViewFrame
    textView.sizeToFit()
    reCenterTextView(atPoint: rect.center)

    textView.isHidden = false
    textView.isEditable = true

    canvasView.window?.makeFirstResponder(textView)
  }

  func showTextView(atPoint point: CGPoint, text: NSAttributedString? = nil, constrainedSize: CGSize? = nil) {
    let textViewFrame = CGRect(center: point, size: CGSize(width: 60, height: 25))
    showTextView(inRect: textViewFrame, text: text, constrainedSize: constrainedSize)
  }

  func dismissTextView() {
    textStorage.setAttributedString(NSAttributedString(string: ""))
    textView.setFrameOrigin(CGPoint.zero)
    textView.isEditable = false
    textView.isHidden = true

    canvasView.window?.makeFirstResponder(canvasView)
  }

  func reCenterTextView(atPoint centerPoint: CGPoint) {
    textView.setFrameOrigin(
      CGPoint(
        x: centerPoint.x - textView.frame.width / 2,
        y: centerPoint.y - textView.frame.height / 2
      )
    )
  }
}
