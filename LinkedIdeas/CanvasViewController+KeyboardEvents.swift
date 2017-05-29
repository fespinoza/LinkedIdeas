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
    case tab = 48
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
    case .tab:
      selectNextConcept()
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

  private func insertConceptAtRandomPoint() {
    let randomX = CGFloat(
      arc4random_uniform(UInt32(canvasView.visibleRect.width)) + UInt32(canvasView.visibleRect.origin.x)
    )
    let randomY = CGFloat(
      arc4random_uniform(UInt32(canvasView.visibleRect.height)) + UInt32(canvasView.visibleRect.origin.y)
    )

    let randomPoint = NSPoint(x: randomX, y: randomY)
    safeTransiton { try stateManager.toNewConcept(atPoint: randomPoint) }
  }

  private func selectNextConcept() {
    switch currentState {
    case .canvasWaiting:
      if let firstConcept = document.concepts.first {
        safeTransiton {
          try stateManager.toSelectedElement(element: firstConcept)
        }
      }
    case .selectedElement(let element):
      if let concept = element as? Concept {
        let conceptIndex = document.concepts.index(of: concept)!
        let nextConceptIndex = conceptIndex + 1
        if document.concepts.count > nextConceptIndex {
          let nextConcept = document.concepts[nextConceptIndex]
          safeTransiton {
            try stateManager.toSelectedElement(element: nextConcept)
          }
        } else {
          safeTransiton {
            try stateManager.toSelectedElement(element: document.concepts.first!)
          }
        }
      }
    default:
      break
    }
  }
}
