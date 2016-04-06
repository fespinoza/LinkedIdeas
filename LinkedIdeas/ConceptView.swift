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
  func pressDeleteKey()
  func cancelEdition()
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
  var canvas: CanvasView { get }
  
  func pointInCanvasCoordinates(point: NSPoint) -> NSPoint
}

extension CanvasElement {
  func pointInCanvasCoordinates(point: NSPoint) -> NSPoint {
    return canvas.pointInCanvasCoordinates(point)
  }
}

protocol ConceptViewProtocol {
  var concept: Concept { get }
  
  func updateFrameToMatchConcept()
}

protocol DraggableElement {
  func dragTo(point: NSPoint)
}

class ConceptView: NSView, NSTextFieldDelegate, StringEditableView, CanvasElement, ClickableView, DraggableElement {
  var concept: Concept { didSet { toggleTextFieldEditMode() } }
  var textField: NSTextField
  var textFieldSize: NSSize { return textField.bounds.size }
  // MARK: - Canvas
  var canvas: CanvasView
  // Extras
  var isTextFieldFocused: Bool = false
  
  override var acceptsFirstResponder: Bool { return true }

  private let defaultTextFieldSize = NSMakeSize(60, 20)

  init(concept: Concept, canvas: CanvasView) {
    let textFieldRect = NSRect(origin: NSMakePoint(0, 0), size: defaultTextFieldSize)
    self.concept = concept
    self.textField = NSTextField(frame: textFieldRect)
    self.canvas = canvas

    super.init(frame: concept.minimalRect)

    textField.delegate = self
    addSubview(textField)
  }

  override var description: String {
    return "\(bounds) \(frame) \(concept.description)"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - NSView
  override func drawRect(dirtyRect: NSRect) {
    if concept.isSelected {
      NSColor.greenColor().set()
      NSRectFill(bounds)
    }
    
    toggleTextFieldEditMode()
    if !concept.isEditable { drawString() }
  }

  // MARK: - Mouse events

  override func mouseDown(theEvent: NSEvent) {
    sprint("mouse down")
    let point = pointInCanvasCoordinates(theEvent.locationInWindow)
    if (theEvent.clickCount == 2) {
      doubleClick(point)
    } else {
      click(point)
    }
  }

  override func mouseDragged(theEvent: NSEvent) {
    sprint("mouse drag")
    let point = pointInCanvasCoordinates(theEvent.locationInWindow)
    dragTo(point)
  }

  override func mouseUp(theEvent: NSEvent) {
    sprint("mouse up")
    let point = pointInCanvasCoordinates(theEvent.locationInWindow)
    dragTo(point)
    canvas.releaseMouseFromConceptView(self, point: point)
  }
  
  // MARK: - Keyboard Events
  
  let deleteKeyCode: UInt16 = 51
  override func keyDown(theEvent: NSEvent) {
    if (theEvent.keyCode == deleteKeyCode) { pressDeleteKey() }
  }

  // MARK: - NSTextFieldDelegate

  func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
    sprint("use selector \(commandSelector)")
    switch commandSelector {
    case #selector(NSResponder.insertNewline(_:)):
      pressEnterKey()
      return true
    case #selector(NSResponder.cancelOperation(_:)):
      cancelEdition()
      return true
    default:
      return false
    }
  }

  // MARK: - ClickableView
  
  func click(point: NSPoint) {
    concept.isSelected = !concept.isSelected
    needsDisplay = true
    updateFrameToMatchConcept()
    canvas.clickOnConceptView(self, point: point)
    becomeFirstResponder()
  }

  func doubleClick(point: NSPoint) {
    concept.isEditable = true
    isTextFieldFocused = false
    needsDisplay = true
    textField.stringValue = concept.stringValue
    canvas.clickOnConceptView(self, point: point)
  }

  // MARK: - StringEditableView
  
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
    updateFrameToMatchConcept()
    canvas.saveConcept(self)
  }
  
  func cancelEdition() {
    if (canvas.isConceptSaved(concept)) {
      disableTextField()
      concept.isEditable = false
      updateFrameToMatchConcept()
    } else {
      canvas.cleanNewConcept()
    }
  }
  
  func pressDeleteKey() {
    canvas.removeConceptView(self)
  }

  // draw concept string
  func drawString() {
    let stringSize = concept.stringValue.sizeWithAttributes(nil)
    let stringRect = NSRect(center: bounds.center, size: stringSize)
    NSColor.blackColor().set()
    concept.stringValue.drawInRect(stringRect, withAttributes: nil)
  }

  // MARK: - Dragable element
  func dragTo(point: NSPoint) {
    sprint("drag")
    if (canvas.mode == .Select) {
      concept.point = point
      updateFrameToMatchConcept()
    }
    canvas.dragFromConceptView(self, point: point)
  }
  
  // MARK: - ConceptViewProtocol
  func updateFrameToMatchConcept() {
    frame = concept.minimalRect
  }
  
  // MARK: - Debugging
  func sprint(message: String) {
    Swift.print("[ConceptView][\(concept.identifier)][\(concept.stringValue)]: \(message)")
  }
}
