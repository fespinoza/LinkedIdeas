//
//  CanvasViewController+NSTextFieldDelegate.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

// MARK: - CanvasViewController+NSTextFieldDelegate

extension CanvasViewController: NSTextFieldDelegate {
  override func controlTextDidChange(_ obj: Notification) {
    if let textField = obj.object as? NSTextField {
      textFieldResizingBehavior.resize(textField)
    }
  }

  // Invoked when users press keys with predefined bindings in a cell of the specified control.
  func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
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
        safeTransiton {
          try stateManager.toCanvasWaiting(savingConceptWithText: control.attributedStringValue)
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
