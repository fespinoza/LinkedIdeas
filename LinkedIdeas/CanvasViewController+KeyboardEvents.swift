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
  override func keyDown(with event: NSEvent) {
    let enterKeyCode: UInt16 = 36
    let deleteKeyCode: UInt16 = 51

    switch event.keyCode {
    case enterKeyCode:
      if event.modifierFlags.contains(.shift) {

        let randomX = CGFloat(
          arc4random_uniform(UInt32(canvasView.visibleRect.width)) + UInt32(canvasView.visibleRect.origin.x)
        )
        let randomY = CGFloat(
          arc4random_uniform(UInt32(canvasView.visibleRect.height)) + UInt32(canvasView.visibleRect.origin.y)
        )

        let randomPoint = NSPoint(x: randomX, y: randomY)
        safeTransiton { try stateManager.toNewConcept(atPoint: randomPoint) }
      } else {
        enterKeyPressed()
      }
    case deleteKeyCode:
      deleteKeyPressed()
    default:
      break
    }
  }

  func enterKeyPressed() {
    switch currentState {
    case .selectedElement(let element):
      safeTransiton {
        try stateManager.toEditingElement(element: element)
      }
    default:
      break
    }
  }

  func deleteKeyPressed() {
    switch currentState {
    case .selectedElement(let element):
      safeTransiton {
        try stateManager.toCanvasWaiting(deletingElements: [element])
      }
    case .multipleSelectedElements(let elements):
      safeTransiton {
        try stateManager.toCanvasWaiting(deletingElements: elements)
      }
    default:
      break
    }
  }
}
