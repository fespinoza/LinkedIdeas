//
//  CanvasViewController+KeyboardEvents.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

// MARK: - CanvasViewController+KeyboardEvents

extension CanvasViewController {
  enum KeyCodes: UInt16 {
    case enter = 36
    case delete = 51
  }

  override func keyDown(with event: NSEvent) {
    guard let handledKeyCode = KeyCodes.init(rawValue: event.keyCode) else {
      return
    }

    switch handledKeyCode {
    case .enter:
      if isPressingShift(event: event) {
        insertConceptAtRandomPoint()
      } else {
        editSelectedConcept()
      }
    case .delete:
      removeSelectedConcepts()
    }
  }

  // MARK: - Internal implementation functions

  private func editSelectedConcept() {
    if let selectedElement = singleSelectedElement() {
      safeTransiton {
        try stateManager.toEditingElement(element: selectedElement)
      }
    }
  }

  private func removeSelectedConcepts() {
    if let elements = selectedElements() {
      safeTransiton {
        try stateManager.toCanvasWaiting(deletingElements: elements)
      }
    }
  }
}
