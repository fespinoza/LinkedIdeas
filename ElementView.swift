//
//  GraphElement.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/01/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

// - [ ] allow concept view to be selected
// - [ ] edit concept view when pressing enter
// - [ ] edit concept view when clicking
// - [ ] delete concept when selected and pressing delete

// protocol Element {
//   var identifier: String { get }
//   var stringValue: String { get set }
//   var editing: Bool { get set }
//   
// }
protocol TextEditable {
  var textField: NSTextField { get set }
  
  func enableTextField()
  func disableTextField()
}

extension TextEditable {
  func enableTextField() {
    textField.hidden = false
    textField.editable = true
  }
  
  func disableTextField() {
    textField.hidden = true
    textField.editable = false
  }
}

class ElementView: NSView, TextEditable {
  let element: Element
  weak var canvas: CanvasView?
  var textField: NSTextField
  
  init(frame frameRect: NSRect, element: Element, canvas: CanvasView) {
    self.element = element
    self.canvas = canvas
    self.textField = NSTextField()
    super.init(frame: frameRect)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(dirtyRect: NSRect) {
    if !element.editing {
      disableTextField()
    }
  }
  
  // MARK: - Mouse Events
  override func mouseDown(theEvent: NSEvent) {
    lockFocus()
    drawFocusRingMask()
    
    if theEvent.clickCount == 2 {
      element.editing = true
      needsDisplay = true
    }
  }
}

//protocol ElementView {
//}

// protocol Selectable {
// }
// 
// protocol Deletable {
//   func removeElement()
// }
// 
// protocol Editable {
//   var textField: NSTextField { get }
// }