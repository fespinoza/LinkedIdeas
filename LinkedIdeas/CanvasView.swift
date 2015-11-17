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
  var mode: Mode?
  var concepts = [Concept]() {
    didSet {
      sprint("concepts length: \(concepts.count)")
      needsDisplay = true
    }
  }
  var arrowStart: NSPoint? {
    didSet {
      needsDisplay = true
    }
  }
  var arrowEnd: NSPoint? {
    didSet {
      needsDisplay = true
    }
  }
  
  override func accessibilityRole() -> String? {
    return NSAccessibilityLayoutAreaRole
  }
  
  override func accessibilityTitle() -> String? {
    return "ACanvasView"
  }
  
  override func accessibilityIsIgnored() -> Bool {
    return false
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    
    // Drawing code here.
    NSColor.whiteColor().set()
    NSBezierPath(rect: bounds).fill()
    
    if mode == Mode.Links {
      sprint("link mode")
      if let arrowStart = arrowStart, arrowEnd = arrowEnd {
        sprint("render arrow")
        NSColor.blackColor().set()
        let path = NSBezierPath()
        path.moveToPoint(arrowStart)
        path.lineToPoint(arrowEnd)
        path.stroke()
      }
    }
    
    if mode == Mode.Concepts {
      sprint("concept mode")
      for concept in concepts {
        if !concept.added {
          sprint("add concept view")
          let conceptView = ConceptView(frame: concept.rect)
          conceptView.concept = concept
          concept.added = true
          addSubview(conceptView)
          conceptView.canvas = self
        }
      }
    }
  }
  
  override func mouseDown(theEvent: NSEvent) {
    sprint("canvasView: mouse down")
    if mode == Mode.Concepts {
      delegate?.singleClick(theEvent)
    } else {
      arrowStart = convertPoint(theEvent.locationInWindow, fromView: nil)
    }
  }
  
  override func mouseDragged(theEvent: NSEvent) {
    if mode == Mode.Links {
      sprint("mouse dragged")
      arrowEnd = convertPoint(theEvent.locationInWindow, fromView: nil)
    }
  }
  
  override func mouseUp(theEvent: NSEvent) {
    if mode == Mode.Links {
      sprint("mouse up")
      arrowStart = nil
      arrowEnd = nil
    }
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
