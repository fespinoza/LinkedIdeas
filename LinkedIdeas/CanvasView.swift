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

class CanvasView: NSControl {
  
  var delegate: CanvasViewDelegate?
  var concepts = [Concept]() {
    didSet {
      sprint("concepts length: \(concepts.count)")
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
        concept.editing = true
        addSubview(conceptView)
        conceptView.canvas = self
      } else {
        concept.editing = false
      }
    }
  }
  
  override func mouseDown(theEvent: NSEvent) {
    delegate?.singleClick(theEvent)
  }
  
  
  func removeConcept(concept: Concept) {
    sprint("removing concept \(concept.identifier)")
    let index = concepts.indexOf({ $0.identifier == concept.identifier })
    if let index = index {
      sprint("remove concept")
      concepts.removeAtIndex(index)
    } else {
      sprint("concept not found")
    }
  }
  
}

extension NSView {
  func sprint(message: String) {
    Swift.print(message)
  }
}
