//
//  ConceptView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 07/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class ConceptView: NSControl, NSTextFieldDelegate {
  
  var concept: Concept? {
    didSet {
      needsDisplay = true
    }
  }
  var editMode = true {
    didSet {
      needsDisplay = true
    }
  }
  var renderedConcept = false
  var textField: NSTextField?
  weak var canvas: CanvasView?
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    sprint("draw rect")
    
    if let concept = concept where !renderedConcept {
      Swift.print("concept view \(concept.identifier)")
      let textField = NSTextField(frame: bounds)
      textField.placeholderString = concept.stringValue
      textField.enabled = true
      textField.editable = true
      addSubview(textField)
      textField.becomeFirstResponder()
      renderedConcept = true
      textField.delegate = self
      self.textField = textField
    }
    
    if renderedConcept {
      if editMode {
        textField?.hidden = false
        textField?.editable = true
      } else {
        renderConcept()
      }
    }
  }
  
  // MARK: - NSTextFieldDelegate
  
  override func mouseDown(theEvent: NSEvent) {
    sprint("conceptView: mouse down \(concept?.identifier)")
    editMode = true
  }
  
  func control(control: NSControl, textShouldBeginEditing fieldEditor: NSText) -> Bool {
    sprint("begin editing \(fieldEditor.string) \(concept?.identifier)")
    beforeEditing()
    return true
  }
  
  func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
    if let concept = concept, textField = textField {
      concept.stringValue = textField.stringValue
    }
    sprint("end editing \(concept?.stringValue)")
    afterEditing()
    return true
  }
  
  func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
    sprint("do command \(commandSelector.description)")
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
  
  override func insertNewline(sender: AnyObject?) {
    sprint("insert new line")
    afterEditing()
  }
  
  override func cancelOperation(sender: AnyObject?) {
    sprint("custom cancel operation")
    afterEditing()
    canvas?.removeConcept(concept!)
    removeFromSuperview()
  }
  
  func afterEditing() {
    textField?.editable = false
    textField?.bordered = false
    textField?.resignFirstResponder()
    textField?.hidden = true
    editMode = false
    canvas?.becomeFirstResponder()
  }
  
  func renderConcept() {
    if let concept = concept, textField = textField {
      concept.stringValue = textField.stringValue
      let attrs = [
        NSForegroundColorAttributeName: NSColor.blackColor()
      ]
      concept.stringValue.drawInRect(bounds, withAttributes: attrs)
    }
  }
  
  func beforeEditing() {
    textField?.editable = true
    textField?.hidden = false
  }
  
  override func keyDown(theEvent: NSEvent) {
    sprint("key down \(theEvent.characters)")
  }
  
  override func sprint(message: String) {
    super.sprint("ConceptView \(concept?.identifier): \(message)")
  }
}
