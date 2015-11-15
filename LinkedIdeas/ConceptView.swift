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
  var renderedConcept = false
  var textField: NSTextField?
  weak var canvas: CanvasView?
  
  override func accessibilityRole() -> String? {
    return NSAccessibilityLayoutItemRole
  }
  
  override func accessibilityTitle() -> String? {
    if let concept = concept {
      return "AConceptView \(concept.identifier)"
    }
    return "AConceptView blank"
  }
  
  override func accessibilityIsIgnored() -> Bool {
    return false
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    sprint("draw rect")
    
    if let concept = concept {
      if !renderedConcept {
        sprint("adding text field")
        
        let textField = NSTextField(frame: bounds)
        textField.placeholderString = concept.stringValue
        textField.enabled = true
        textField.editable = true
        textField.delegate = self
        
        addSubview(textField)
        textField.becomeFirstResponder()
        
        self.textField = textField
        renderedConcept = true
        
        if !concept.editing {
          sprint("concept not editing")
          disableTextField()
          justRenderConcept()
        }
      } else {
        if concept.editing {
          sprint("edit concept")
          enableTextField()
        } else {
          sprint("just render it")
          renderConcept()
        }
      }
    }
  }
  
  func enableTextField() {
    if let textField = textField {
      textField.hidden = false
      textField.editable = true
    }
  }
  
  func disableTextField() {
    if let textField = textField {
      textField.hidden = true
      textField.editable = false
    }
  }
  
  // MARK: - NSTextFieldDelegate
  
  override func mouseDown(theEvent: NSEvent) {
    if let concept = concept {
      concept.editing = true
      needsDisplay = true
    }
    sprint("conceptView: mouse down \(concept?.identifier)")
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
    sprint("after editing")
    disableTextField()
    textField?.resignFirstResponder()
    canvas?.becomeFirstResponder()
    concept?.editing = false
  }
  
  func renderConcept() {
    if let concept = concept, textField = textField {
      concept.stringValue = textField.stringValue
      justRenderConcept()
    }
  }
  
  func justRenderConcept() {
    if let concept = concept {
      let attrs = [
        NSForegroundColorAttributeName: NSColor.blackColor()
      ]
      concept.stringValue.drawInRect(bounds, withAttributes: attrs)
    }
  }
  
  func beforeEditing() {
    sprint("before editing")
    enableTextField()
    concept?.editing = true
  }
  
  override func keyDown(theEvent: NSEvent) {
    sprint("key down \(theEvent.characters)")
  }
  
  override func sprint(message: String) {
    if let concept = concept {
      super.sprint("ConceptView [\(concept)]: \(message)")
    }
  }
}
