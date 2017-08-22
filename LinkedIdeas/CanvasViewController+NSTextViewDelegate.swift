//
//  CanvasViewController+NSTextViewDelegate.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 20/08/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension CanvasViewController: NSTextViewDelegate {
  func textDidChange(_ notification: Notification) {
    guard let textView = notification.object as? NSTextView else {
      preconditionFailure("noooo")
    }

    // re-center textView
    textView.setFrameOrigin(
      NSPoint(
        x: currentEditingConceptCenterPoint.x - textView.frame.width / 2,
        y: currentEditingConceptCenterPoint.y - textView.frame.height / 2
      )
    )
  }

  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    switch commandSelector {
    case #selector(NSResponder.insertNewline(_:)):
      endEditing()
      return true
    default:
      return false
    }
  }
}

// MARK: - textView manipulation methods
extension CanvasViewController {
  func startEditing(concept: Concept) {
    editingConcept = concept
    textStorage.setAttributedString(concept.attributedStringValue)
    let textViewFrame = concept.area
    textView.frame = textViewFrame
    textView.sizeToFit()
    currentEditingConceptCenterPoint = textView.frame.center

    textView.isHidden = false
    textView.isEditable = true

    view.window?.makeFirstResponder(textView)
  }

  func endEditing() {
//    if var editingConcept = editingConcept, let text = textView.attributedString().copy() as? NSAttributedString {
//      editingConcept = Concept(
//        attributedStringValue: text,
//        centerPoint: editingConcept.centerPoint
//      )
//      concepts.remove(at: concepts.index(where: { (concept) -> Bool in
//        return concept.centerPoint == editingConcept.centerPoint
//      })!)
//      concepts.append(editingConcept)
//
//      textView.isHidden = true
//      textView.isEditable = false
//    }
//
//    editingConcept = nil
//    view.needsDisplay = true
  }
}
