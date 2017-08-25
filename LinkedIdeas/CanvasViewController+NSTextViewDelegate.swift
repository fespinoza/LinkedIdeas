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
    var textViewCenterPoint: CGPoint

    switch currentState {
    case .editingElement(let element):
      textViewCenterPoint = element.centerPoint
    case .newConcept(let point):
      textViewCenterPoint = point
    default:
      preconditionFailure("there is no point to center to")
    }

    reCenterTextView(atPoint: textViewCenterPoint)
  }

  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    switch commandSelector {
    case #selector(NSResponder.cancelOperation(_:)):
      safeTransiton {
        try stateManager.toCanvasWaiting()
      }
      return true
    case #selector(NSResponder.insertNewline(_:)):
      switch currentState {
      case .editingElement(let element):
        safeTransiton {
          try stateManager.toSelectedElementSavingChanges(element: element)
        }
      case .newConcept:
        guard let text = textView.attributedString().copy() as? NSAttributedString else {
          preconditionFailure("uh? this should have been an attributed string")
        }
        safeTransiton {
          try stateManager.toCanvasWaiting(savingConceptWithText: text)
        }
      default:
        break
      }
      return true
    default:
      return false
    }

  }
}
