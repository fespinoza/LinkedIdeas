//
//  CanvasView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol CanvasViewDelegate {
  // mouse events
  func singleClick(event:NSEvent)
}

class CanvasView: NSView {
  
  var delegate: CanvasViewDelegate?
  var concepts = [Concept]() {
    didSet {
      needsDisplay = true
    }
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    
    // Drawing code here.
    NSColor.whiteColor().set()
    NSBezierPath(rect: bounds).fill()
    
    for concept in concepts {
      if !concept.added {
        concept.added = true
        let textField = NSTextField(frame: concept.rect)
        textField.placeholderString = concept.stringValue
        textField.enabled = true
        textField.editable = true
        addSubview(textField)
        textField.becomeFirstResponder()
      }
    }
  }
  
  override func mouseDown(theEvent: NSEvent) {
    delegate?.singleClick(theEvent)
  }
}