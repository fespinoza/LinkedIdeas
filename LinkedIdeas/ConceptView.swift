//
//  ConceptView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 07/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol StringEditableView {
  var textField: NSTextField { get }
  var textFieldSize: NSSize { get }
  var isTextFieldFocused: Bool { get set }
  
  func editingString() -> Bool
  func toggleTextFieldEditMode()
  func enableTextField()
  func disableTextField()
  func focusTextField()
  
  func drawString()
  
  func typeText(string: String)
  func pressEnterKey()
}

extension StringEditableView {
  func editingString() -> Bool {
    return !textField.hidden
  }
  
  func enableTextField() {
    textField.hidden = false
    textField.enabled = true
    focusTextField()
  }
  
  func disableTextField() {
    textField.hidden = true
    textField.enabled = false
  }
  
  func typeText(string: String) {
    textField.stringValue = string
  }
}

protocol CanvasElement {
  var canvas: Canvas { get }
}

protocol ConceptViewProtocol {
  var concept: Concept { get }
}

class ConceptView: NSView, NSTextFieldDelegate, StringEditableView, CanvasElement, ClickableView {
  var concept: Concept { didSet { toggleTextFieldEditMode() } }
  var textField: NSTextField
  var textFieldSize: NSSize { return textField.bounds.size }
  // MARK: - Canvas
  var canvas: Canvas
  // Extras
  var isTextFieldFocused: Bool = false
  
  private let defaultTextFieldSize = NSMakeSize(60, 20)
  
  init(concept: Concept, canvas: Canvas) {
    let textFieldRect = NSRect(origin: NSMakePoint(0, 0), size: defaultTextFieldSize)
    self.concept = concept
    self.textField = NSTextField(frame: textFieldRect)
    self.canvas = canvas
    
    super.init(frame: concept.minimalRect)
    
    textField.delegate = self
    addSubview(textField)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - NSView
  override func drawRect(dirtyRect: NSRect) {
    if concept.isSelected {
      NSColor.greenColor().set()
      NSRectFill(bounds)
      toggleTextFieldEditMode()
    }
    if !concept.isEditable { drawString() }
  }
  
  // MARK: - Mouse events
  
  override func mouseDown(theEvent: NSEvent) {
    let point = convertPoint(theEvent.locationInWindow, fromView: nil)
    if (theEvent.clickCount == 2) {
      doubleClick(point)
    } else {
      click(point)
    }
  }
  
  // MARK: - NSTextFieldDelegate
  
  func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
    switch commandSelector {
    case "insertNewline:":
      pressEnterKey()
      return true
    default:
      return false
    }
  }
  
  // MARK: - ClickableView
  func click(point: NSPoint) {
    concept.isSelected = !concept.isSelected
    needsDisplay = true
  }
  
  func doubleClick(point: NSPoint) {
    concept.isEditable = true
    isTextFieldFocused = false
    needsDisplay = true
  }
  
  // MARK: - string editable view
  func toggleTextFieldEditMode() {
    if concept.isEditable {
      enableTextField()
    } else {
      disableTextField()
    }
  }
  
  func focusTextField() {
    if !isTextFieldFocused {
      textField.becomeFirstResponder()
      isTextFieldFocused = true
    }
  }
  
  func pressEnterKey() {
    disableTextField()
    concept.isEditable = false
    concept.stringValue = textField.stringValue
    canvas.saveConcept(self)
  }
  
  // draw concept string
  func drawString() {
    let stringSize = concept.stringValue.sizeWithAttributes(nil)
    let stringRect = NSRect(center: bounds.center, size: stringSize)
    NSColor.blackColor().set()
    concept.stringValue.drawInRect(stringRect, withAttributes: nil)
  }
}

//class ConceptView: NSView {
//  var concept: Concept { didSet { needsDisplay = true } }
//  var added = false
//  var canvas: CanvasView
//  let textField: NSTextField
//  
//  var hoverTrackingArea: NSTrackingArea {
//    return NSTrackingArea(
//      rect: bounds,
//      options: [.MouseEnteredAndExited, .ActiveInKeyWindow],
//      owner: self,
//      userInfo: nil
//    )
//  }
//  
//  init(frame frameRect: NSRect, concept: Concept, canvas: CanvasView) {
//    self.concept = concept
//    textField = NSTextField()
//    self.canvas = canvas
//    
//    super.init(frame: frameRect)
//    
//    initTextField()
//    addTrackingArea(hoverTrackingArea)
//  }
//  
//  func initTextField() {
//    textField.placeholderString = Concept.placeholderString
//    textField.frame = NSRect(center: bounds.center, size: textFieldSize())
//    textField.alignment = .Center
//    textField.delegate = self
//    addSubview(textField)
//  }
//  
//  func textFieldSize() -> NSSize {
//    if concept.stringValue == "" {
//      return NSMakeSize(80, 30)
//    } else {
//      return concept.stringValue.sizeWithAttributes(nil)
//    }
//  }
//  
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  
//  override func drawRect(dirtyRect: NSRect) {
//    super.drawRect(dirtyRect)
//    sprint("drawRect")
//    
//    if concept.editing {
//      enableTextField()
//    } else {
//      drawConceptString()
//      disableTextField()
//    }
//    
//    if !added {
//      textField.becomeFirstResponder()
//      added = true
//    }
//  }
//  
//  // MARK: - drawing
//  
//  func enableTextField() {
//    sprint("enable text field")
//    textField.editable = true
//    textField.hidden = false
//  }
//  
//  func disableTextField() {
//    sprint("disable text field")
//    textField.editable = false
//    textField.hidden = true
//  }
//  
//  func drawConceptString() {
//    sprint("draw Concept")
//    let stringSize = concept.stringValue.sizeWithAttributes(nil)
//    let stringRect = NSRect(center: bounds.center, size: stringSize)
//    NSColor.cyanColor().set()
//    NSRectFill(stringRect)
//    concept.stringValue.drawInRect(stringRect, withAttributes: nil)
//  }
//
//  // MARK: - accessibility
//  
//  override func accessibilityRole() -> String? {
//    return NSAccessibilityLayoutItemRole
//  }
//  
//  override func accessibilityTitle() -> String? {
//    return "AConceptView-\(concept.stringValue)"
//  }
//  
//  override func accessibilityIsIgnored() -> Bool { return false }
//  
//  // MARK: - NSTextFieldDelegate
//  
//  func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
//    switch commandSelector {
//    case "insertNewline:":
//      insertNewline(control)
//      return true
//    case "cancelOperation:":
//      cancelOperation(control)
//      return true
//    default:
//      return false
//    }
//  }
//  
//  func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
//    sprint("begin editing")
//    return true
//  }
//  
//  func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
//    concept.stringValue = textField.stringValue
//    sprint("end editing \(concept.stringValue)")
//    return true
//  }
//  
//  override func insertNewline(sender: AnyObject?) {
//    sprint("insertNewLine")
//    disableTextField()
//    concept.editing = false
//  }
//  
//  override func cancelOperation(sender: AnyObject?) {
//    sprint("cancelOperation")
//    removeFromSuperview()
//  }
//  
//  override func keyDown(theEvent: NSEvent) {
//    sprint("key down")
//  }
//
//  // MARK: - Mouse events
//  
//  override func mouseEntered(theEvent: NSEvent) {
//    canvas.targetConceptIdentifier = concept.identifier
//  }
//  
//  override func mouseExited(theEvent: NSEvent) {
//    canvas.targetConceptIdentifier = nil
//  }
//  
//  override func mouseDown(theEvent: NSEvent) {
//    sprint("mouse down")
//    canvas.mouseDownFromConcept(theEvent)
//    canvas.originConceptIdentifier = concept.identifier
//    
//    if canvas.mode == Mode.Concepts && theEvent.clickCount == 2 {
//      concept.editing = true
//      enableTextField()
//      textField.becomeFirstResponder()
//    }
//  }
//  
//  override func mouseDragged(theEvent: NSEvent) {
//    sprint("mouse dragged")
//    if canvas.mode == Mode.Concepts {
//      canvas.moveConceptView(self, theEvent: theEvent)
//    }
//    canvas.mouseDragged(theEvent)
//  }
//  
//  override func mouseUp(theEvent: NSEvent) {
//    sprint("mouseUp")
//    
//    canvas.mouseUp(theEvent)
//    canvas.originConceptIdentifier = nil
//  }
//
//}