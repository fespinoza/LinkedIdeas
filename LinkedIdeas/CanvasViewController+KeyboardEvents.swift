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

    if event.keyCode == enterKeyCode {
      Swift.print("enter event!")

      switch currentState {
      case .selectedElement(let element):
        safeTransiton {
          try stateManager.toEditingElement(element: element)
        }
      default:
        Swift.print("do nothing")
      }
    }
  }
}
