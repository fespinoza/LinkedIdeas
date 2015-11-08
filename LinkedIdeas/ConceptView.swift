//
//  ConceptView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 07/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class ConceptView: NSView {
  
  var concept: Concept? {
    didSet {
      needsDisplay = true
    }
  }
  var renderedConcept = false
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    
    if let concept = concept where !renderedConcept {
      Swift.print("concept view")
      let textField = NSTextField(frame: bounds)
      textField.placeholderString = concept.stringValue
      textField.enabled = true
      textField.editable = true
      addSubview(textField)
      textField.becomeFirstResponder()
      renderedConcept = true
    }
  }
}
