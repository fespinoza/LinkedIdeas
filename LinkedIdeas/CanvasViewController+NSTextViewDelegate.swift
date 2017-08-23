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
    var textFieldCenterPoint: CGPoint

    switch currentState {
    case .editingElement(let element):
      textFieldCenterPoint = element.centerPoint
    case .newConcept(let point):
      textFieldCenterPoint = point
    default:
      preconditionFailure("there is no point to center to")
    }

    // re-center textView
    textView.setFrameOrigin(
      NSPoint(
        x: textFieldCenterPoint.x - textView.frame.width / 2,
        y: textFieldCenterPoint.y - textView.frame.height / 2
      )
    )
  }

  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    switch commandSelector {
    case #selector(NSResponder.insertNewline(_:)):
      dismissTextView()
      return true
    default:
      return false
    }
  }
}
