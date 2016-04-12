//
//  ConceptView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 07/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class ConceptView: NSView, NSTextFieldDelegate, StringEditableView, CanvasElement, ClickableView, DraggableElement, HoveringView {
  var concept: Concept { didSet { toggleTextFieldEditMode() } }
  var textField: ResizingTextField
  var textFieldSize: NSSize { return textField.bounds.size }
  // MARK: - Canvas
  var canvas: CanvasView
  // Extras
  var isTextFieldFocused: Bool = false
  
  override var acceptsFirstResponder: Bool { return true }
  
  // MARK: - HoveringView
  var isHoveringView: Bool = false {
    didSet { needsDisplay = true }
  }

  private let defaultTextFieldSize = NSMakeSize(60, 20)

  init(concept: Concept, canvas: CanvasView) {
    let textFieldRect = NSRect(origin: NSMakePoint(0, 0), size: defaultTextFieldSize)
    self.concept = concept
    self.textField = ResizingTextField(frame: textFieldRect)
    self.canvas = canvas

    super.init(frame: concept.minimalRect)
    
    enableTrackingArea()
    textField.delegate = self
    addSubview(textField)
    textField.allowsEditingTextAttributes = true
  }

  override var description: String {
    return "[ConceptView][\(concept.identifier)][\(concept.stringValue)]"
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
    drawHoveringState()
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
  
  override func mouseEntered(theEvent: NSEvent) {
    sprint("mouse entered")
    isHoveringView = true
  }
  
  override func mouseExited(theEvent: NSEvent) {
    sprint("mouse exited")
    isHoveringView = false
  }
  
  // MARK: - Keyboard Events
  
  let deleteKeyCode: UInt16 = 51
  override func keyDown(theEvent: NSEvent) {
    if (theEvent.keyCode == deleteKeyCode) {
      pressDeleteKey()
    } else {
      super.keyDown(theEvent)
    }
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
    textField.attributedStringValue = concept.attributedStringValue
    updateFrameToMatchConcept()
    textField.setFrameSize(textField.intrinsicContentSize)
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
    concept.attributedStringValue = textField.attributedStringValue
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
    let stringSize = concept.attributedStringValue.size()
    let stringRect = NSRect(center: bounds.center, size: stringSize)
    NSColor.blackColor().set()
    concept.attributedStringValue.drawInRect(stringRect)
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
    textField.attributedStringValue = concept.attributedStringValue
    frame = NSRect(center: concept.point, size: textField.intrinsicContentSize)
  }
}
