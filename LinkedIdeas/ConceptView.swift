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
  var canvas: CanvasView { get }
}

protocol ConceptViewProtocol {
  var concept: Concept { get }
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
    } else {
      NSColor.lightGrayColor().set()
    }
    NSRectFill(bounds)
    toggleTextFieldEditMode()
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

  override func mouseDragged(theEvent: NSEvent) {
    dragTo(theEvent.locationInWindow)
  }

  override func mouseUp(theEvent: NSEvent) {
    dragTo(theEvent.locationInWindow)
    canvas.releaseMouseFromConceptView(self, point: theEvent.locationInWindow)
  }

  // MARK: - NSTextFieldDelegate

  func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
    switch commandSelector {
    case #selector(NSResponder.insertNewline(_:)):
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
    canvas.clickOnConceptView(self, point: point)
  }

  func doubleClick(point: NSPoint) {
    concept.isEditable = true
    isTextFieldFocused = false
    needsDisplay = true
    canvas.clickOnConceptView(self, point: point)
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

  // MARK - Dragable element
  func dragTo(point: NSPoint) {
    if (canvas.mode == .Concepts) {
      concept.point = point
      frame = concept.minimalRect
    }
    canvas.dragFromConceptView(self, point: point)
  }
}
