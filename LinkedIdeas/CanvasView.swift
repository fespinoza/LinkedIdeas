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
        Swift.print("add concept view")
        let conceptView = ConceptView(frame: concept.rect)
        conceptView.concept = concept
        concept.added = true
        addSubview(conceptView)
      }
    }
  }
  
  override func mouseDown(theEvent: NSEvent) {
    delegate?.singleClick(theEvent)
  }
  
}
