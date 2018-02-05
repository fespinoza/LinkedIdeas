//
//  CanvasViewController+KeyboardEvents.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

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
      selectNextConcept(normalDirection: !isPressingShift(event: event))
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
    let visibleRect = canvasView.visibleRect
    let randomX = CGFloat(arc4random_uniform(UInt32(visibleRect.width)) + UInt32(visibleRect.origin.x))
    let randomY = CGFloat(arc4random_uniform(UInt32(visibleRect.height)) + UInt32(visibleRect.origin.y))

    let randomPoint = CGPoint(x: randomX, y: randomY)
    safeTransiton { try stateManager.toNewConcept(atPoint: randomPoint) }
  }

  private func selectNextConcept(normalDirection: Bool) {
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
        var conceptToSelectIndex = conceptIndex
        if normalDirection {
          conceptToSelectIndex += 1
        } else {
          conceptToSelectIndex -= 1
        }
        conceptToSelectIndex = conceptToSelectIndex < 0 ? document.concepts.count - 1 : conceptToSelectIndex
        conceptToSelectIndex = conceptToSelectIndex % document.concepts.count

        let conceptToSelect = document.concepts[conceptToSelectIndex]
        safeTransiton {
          try stateManager.toSelectedElement(element: conceptToSelect)
        }
      }
    default:
      break
    }
  }
}
