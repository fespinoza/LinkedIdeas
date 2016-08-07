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
  // Mouse events
  var document: LinkedIdeasDocument { return canvas.document }
  
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

    super.init(frame: concept.rect)
    
    enableTrackingArea()
    textField.delegate = self
    addSubview(textField)
    textField.allowsEditingTextAttributes = true
    textField.conceptView = self
  }

  override var description: String {
    return "[ConceptView][\(concept.identifier)][\(concept.stringValue)]"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - NSView
  
  override func draw(_ dirtyRect: NSRect) {
    drawSelectedMark()
    toggleTextFieldEditMode()
    if !concept.isEditable { drawString() }
    drawHoveringState()
  }
  
  func drawSelectedMark() {
    if concept.isSelected {
      let bezierPath = NSBezierPath(rect: bounds)
      NSColor.red.set()
      bezierPath.lineWidth = 3
      bezierPath.stroke()
    }
  }

  // MARK: - Mouse events
  override func mouseDown(with theEvent: NSEvent) {
    let point = pointInCanvasCoordinates(theEvent.locationInWindow)
    initialPoint = concept.point
    if (theEvent.clickCount == 2) {
      doubleClick(point)
    } else {
      if (theEvent.modifierFlags.contains(.shift)) {
        shiftClick(point)
      } else {
        click(point)
      }
    }
  }

  override func mouseDragged(with theEvent: NSEvent) {
    let point = pointInCanvasCoordinates(theEvent.locationInWindow)
    if isDragging {
      dragTo(point)
    } else {
      dragStart(point)
    }
  }

  override func mouseUp(with theEvent: NSEvent) {
    if isDragging {
      let point = pointInCanvasCoordinates(theEvent.locationInWindow)
      dragEnd(point)
    }
    canvas.mouseUp(with: theEvent)
    (window?.windowController as? WindowController)?.selectedElementsCallback()
  }
  
  override func mouseEntered(with theEvent: NSEvent) {
    isHoveringView = true
  }
  
  override func mouseExited(with theEvent: NSEvent) {
    isHoveringView = false
  }
  
  // MARK: - Keyboard Events
  
  let deleteKeyCode: UInt16 = 51
  override func keyDown(with theEvent: NSEvent) {
    if (theEvent.keyCode == deleteKeyCode) {
      pressDeleteKey()
    } else {
      super.keyDown(with: theEvent)
    }
  }

  // MARK: - NSTextFieldDelegate

  func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
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
  
  func textDidChange(_ notification: Notification) {
    updateFrameToMatchConcept()
  }


  // MARK: - ClickableView
  
  func click(_ point: NSPoint) {
    canvas.clickOnConceptView(self, point: point)
    concept.isSelected = true //!concept.isSelected
    needsDisplay = true
    textField.attributedStringValue = concept.attributedStringValue
    updateFrameToMatchConcept()
    becomeFirstResponder()
  }

  func doubleClick(_ point: NSPoint) {
    concept.isEditable = true
    isTextFieldFocused = false
    needsDisplay = true
    textField.attributedStringValue = concept.attributedStringValue
    updateFrameToMatchConcept()
    textField.setFrameSize(textField.intrinsicContentSize)
    canvas.clickOnConceptView(self, point: point)
  }
  
  func shiftClick(_ point: NSPoint) {
    concept.isSelected = !concept.isSelected
    needsDisplay = true
    textField.attributedStringValue = concept.attributedStringValue
    updateFrameToMatchConcept()
    canvas.clickOnConceptView(self, point: point, multipleSelect: true)
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
    if (canvas.concepts.index(of: concept) == nil) {
      canvas.saveConcept(self)
    }
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
    canvas.removeSelectedConceptViews()
  }

  // draw concept string
  func drawString() {
    let stringSize = concept.attributedStringValue.size()
    let stringRect = NSRect(center: bounds.center, size: stringSize)
    NSColor.black.set()
    concept.attributedStringValue.draw(in: stringRect)
  }

  // MARK: - Dragable element
  var isDragging: Bool = false
  var initialPoint: NSPoint?
  var draggableDelegate: DraggableElementDelegate? { return canvas }
  
  func dragStart(_ point: NSPoint, performCallback: Bool = true) {
    initialPoint = concept.point
    isDragging = true
    
    if (canvas.mode == .Select) {
      concept.point = point
      // TODO: this function should be observer from ^
      textField.attributedStringValue = concept.attributedStringValue
      updateFrameToMatchConcept()
    }
    
    if performCallback {
      let dragEvent = DragEvent(fromPoint: initialPoint!, toPoint: point)
      draggableDelegate?.dragStartCallback(self, dragEvent: dragEvent)
    }
  }
  
  func dragTo(_ point: NSPoint, performCallback: Bool = true) {
    let fromPoint = concept.point
    
    if (canvas.mode == .Select) {
      concept.point = point
      // TODO: this function should be observer from ^
      textField.attributedStringValue = concept.attributedStringValue
      updateFrameToMatchConcept()
    }
    
    if performCallback {
      let dragEvent = DragEvent(fromPoint: fromPoint, toPoint: point)
      draggableDelegate?.dragToCallback(self, dragEvent: dragEvent)
    }
  }
  
  func dragEnd(_ lastPoint: NSPoint, performCallback: Bool = true) {
    let fromPoint = concept.point
    
    if let initialPoint = initialPoint, canvas.mode == .Select {
      document.changeConceptPoint(concept, fromPoint: initialPoint, toPoint: lastPoint)
    }
    
    if performCallback {
      let dragEvent = DragEvent(fromPoint: fromPoint, toPoint: lastPoint)
      draggableDelegate?.dragEndCallback(self, dragEvent: dragEvent)
    }
    
    isDragging = false
    initialPoint = nil
  }
  
  // MARK: - ConceptViewProtocol
  
  func updateFrameToMatchConcept() {
    frame = NSRect(center: concept.point, size: textField.intrinsicContentSize)
  }
}
