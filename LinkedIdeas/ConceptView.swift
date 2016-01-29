//
//  ConceptView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 07/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class ConceptView: NSView, NSTextFieldDelegate {
  var concept: Concept { didSet { needsDisplay = true } }
  var added = false
  var canvas: CanvasView
  let textField: NSTextField
  
  var hoverTrackingArea: NSTrackingArea {
    return NSTrackingArea(
      rect: bounds,
      options: [.MouseEnteredAndExited, .ActiveInKeyWindow],
      owner: self,
      userInfo: nil
    )
  }
  
  init(frame frameRect: NSRect, concept: Concept, canvas: CanvasView) {
    self.concept = concept
    textField = NSTextField()
    self.canvas = canvas
    
    super.init(frame: frameRect)
    
    initTextField()
    addTrackingArea(hoverTrackingArea)
  }
  
  func initTextField() {
    textField.placeholderString = Concept.placeholderString
    textField.frame = NSRect(center: bounds.center, size: textFieldSize())
    textField.alignment = .Center
    textField.delegate = self
    addSubview(textField)
  }
  
  func textFieldSize() -> NSSize {
    if concept.stringValue == "" {
      return NSMakeSize(80, 30)
    } else {
      return concept.stringValue.sizeWithAttributes(nil)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    sprint("drawRect")
    
    if concept.editing {
      enableTextField()
    } else {
      drawConceptString()
      disableTextField()
    }
    
    if !added {
      textField.becomeFirstResponder()
      added = true
    }
    
    // debugDrawing()
  }
  
  // MARK: - drawing
  
  func enableTextField() {
    sprint("enable text field")
    textField.editable = true
    textField.hidden = false
  }
  
  func disableTextField() {
    sprint("disable text field")
    textField.editable = false
    textField.hidden = true
  }
  
  func drawConceptString() {
    sprint("draw Concept")
    let stringSize = concept.stringValue.sizeWithAttributes(nil)
    let stringRect = NSRect(center: bounds.center, size: stringSize)
    NSColor.cyanColor().set()
    NSRectFill(stringRect)
    concept.stringValue.drawInRect(stringRect, withAttributes: nil)
  }
  
  override func debugDrawing() {
    super.debugDrawing()
    let conceptPoint = convertPoint(concept.point, fromView: canvas)
    drawCenteredDotAtPoint(conceptPoint, color: NSColor.redColor())
  }
  
  // MARK: - accessibility
  
  override func accessibilityRole() -> String? {
    return NSAccessibilityLayoutItemRole
  }
  
  override func accessibilityTitle() -> String? {
    return "AConceptView \(concept.identifier)"
  }
  
  override func accessibilityIsIgnored() -> Bool { return false }
  
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
    concept.stringValue = textField.stringValue
    sprint("end editing \(concept.stringValue)")
    return true
  }
  
  override func insertNewline(sender: AnyObject?) {
    sprint("insertNewLine")
    disableTextField()
    concept.editing = false
  }
  
  override func cancelOperation(sender: AnyObject?) {
    sprint("cancelOperation")
    removeFromSuperview()
  }
  
  override func keyDown(theEvent: NSEvent) {
    sprint("key down")
  }
  
  // MARK: - Mouse events
  
  override func mouseEntered(theEvent: NSEvent) {
    canvas.targetConceptIdentifier = concept.identifier
  }
  
  override func mouseExited(theEvent: NSEvent) {
    canvas.targetConceptIdentifier = nil
  }
  
  override func mouseDown(theEvent: NSEvent) {
    sprint("mouse down")
    canvas.mouseDownFromConcept(theEvent)
    canvas.originConceptIdentifier = concept.identifier
    if canvas.mode == Mode.Concepts {
      concept.editing = true
      enableTextField()
      textField.becomeFirstResponder()
    }
  }
  
  override func mouseUp(theEvent: NSEvent) {
    canvas.mouseUp(theEvent)
    canvas.originConceptIdentifier = nil
  }
  
  // MARK: - Others
  
  override func sprint(message: String) {
    Swift.print("ConceptView [\(concept.identifier)]: \(message)")
  }
  
}