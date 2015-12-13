//
//  LinkView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 28/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class LinkView: NSView, NSTextFieldDelegate {
  let link: Link
  var editing: Bool
  var added: Bool
  var textField: NSTextField
  let canvas: CanvasView
  
  init(frame frameRect: NSRect, link: Link, canvas: CanvasView) {
    self.link = link
    self.added = false
    self.editing = true
    self.canvas = canvas
    self.textField = NSTextField()
    super.init(frame: frameRect)
    initTextField()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    drawArrow()
    
    if editing {
      drawTextField()
    } else {
      drawStringValue()
    }
    
    if !added {
      textField.becomeFirstResponder()
      added = true
    }
    
    //    debugDrawing()
  }
  
  // MARK: - Drawing methods
  
  func drawStringValue() {
    sprint("draw Concept")
    let stringSize = link.stringValue.sizeWithAttributes(nil)
    let stringRect = NSRect(center: bounds.center, size: stringSize)
    NSColor.whiteColor().set()
    NSRectFill(stringRect)
    link.stringValue.drawInRect(stringRect, withAttributes: nil)
  }
  
  func drawArrow() {
    NSColor.redColor().set()
    let path = NSBezierPath()
    
    let origin = convertPoint(link.originPoint, fromView: canvas)
    let target = convertPoint(link.targetPoint, fromView: canvas)
    
    path.moveToPoint(origin)
    path.lineToPoint(target)
    
    path.stroke()
  }
  
  func drawTextField() {
    toggleTextField()
  }
  
  // MARK: - TextFieldLogic
  
  func initTextField() {
    textField.frame = textFieldRect()
    textField.placeholderString = "name"
    textField.delegate = self
    addSubview(textField)
  }
  
  func textFieldRect() -> NSRect {
    let size = NSSize(width: 30.0, height: 20.0)
    return NSRect(center: bounds.center, size: size)
  }
  
  // MARK: - NSTextFieldDelegate
  
  func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
    switch commandSelector {
    case "insertNewline:":
      insertNewline(control)
      return true
    case "cancelOperation:":
      cancelOperation(control)
      return true
    default:
      return false
    }
  }
  
  func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
    sprint("begin editing")
    return true
  }
  
  func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
    link.stringValue = textField.stringValue
    sprint("end editing \(link.stringValue)")
    return true
  }
  
  override func insertNewline(sender: AnyObject?) {
    sprint("insertNewLine")
    disableTextField()
    editing = false
    needsDisplay = true
  }
  
  override func cancelOperation(sender: AnyObject?) {
    sprint("cancelOperation")
    removeFromSuperview()
  }
  
  override func keyDown(theEvent: NSEvent) {
    sprint("key down")
  }
  
  // MARK: - TextField events
  
  func toggleTextField() {
    if editing {
      enableTextField()
    } else {
      disableTextField()
    }
  }
  
  func enableTextField() {
    textField.hidden = false
    textField.editable = true
  }
  
  func disableTextField() {
    textField.hidden = true
    textField.editable = false
  }
  
  // MARK: - Mouse Events
  
  override func mouseDown(theEvent: NSEvent) {
    sprint("clicking on link")
    editing = true
    enableTextField()
    textField.becomeFirstResponder()
  }
  
  // MARK: - others
  
  func desc() -> String {
    return "\(bounds.origin.description()) [\(bounds.size.width), \(bounds.size.height)]"
  }
}