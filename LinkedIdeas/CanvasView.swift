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
  var concepts = [Concept]() { didSet { needsDisplay = true } }
  var links = [Link]() { didSet { needsDisplay = true } }
  var arrowStart: NSPoint? { didSet { needsDisplay = true } }
  var arrowEnd: NSPoint? { didSet { needsDisplay = true } }
  var clicks = [NSPoint]() { didSet { needsDisplay = true } }
  var originConceptIdentifier: Int?
  var targetConceptIdentifier: Int?
  
  // MARK: - accessibility
  
  override func accessibilityRole() -> String? {
    return NSAccessibilityLayoutAreaRole
  }
  
  override func accessibilityTitle() -> String? {
    return "ACanvasView"
  }
  
  override func accessibilityIsIgnored() -> Bool {
    return false
  }
  
  // MARK: - NSView defaults
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    
    // Drawing code here.
    NSColor.whiteColor().set()
    NSBezierPath(rect: bounds).fill()
    
    if mode == Mode.Links {
      drawCreationLinkArrow()
    }
    
    for link in links { addLinkView(link) }
    for concept in concepts { addConceptView(concept) }
  }
  
  // MARK: - Drawing Functions
  
  func drawCreationLinkArrow() {
    if let arrowStart = arrowStart, arrowEnd = arrowEnd {
      sprint("render arrow")
      NSColor.blackColor().set()
      let path = NSBezierPath()
      path.moveToPoint(arrowStart)
      path.lineToPoint(arrowEnd)
      path.stroke()
    }
  }
  
  // MARK: - Mouse Events
  
  override func mouseDown(theEvent: NSEvent) {
    sprint("canvasView: mouse down")
    let point = convertPoint(theEvent.locationInWindow, fromView: nil)
    clicks.append(point)
    
    for concept in concepts {
      concept.editing = false
    }
    
    if mode == Mode.Concepts {
      delegate?.singleClick(theEvent)
    } else {
      arrowStart = convertPoint(theEvent.locationInWindow, fromView: nil)
    }
  }
  
  func mouseDownFromConcept(theEvent: NSEvent) {
    if mode == Mode.Links {
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
      if let targetConceptIdentifier = targetConceptIdentifier, originConceptIdentifier = originConceptIdentifier where originConceptIdentifier != targetConceptIdentifier {
        sprint("calling creating link")
        createLink(originConceptIdentifier, targetConceptIdentifier)
      }
      removeArrow()
    }
  }
  
  // MARK: - Link Functions
  
  func removeArrow() {
    arrowStart = nil
    arrowEnd = nil
  }
  
  func createLink(originIdentifier: Int, _ targetIdentifier: Int) {
    let origin = concepts.filter({ element in element.identifier == originIdentifier }).first
    let target = concepts.filter({ element in element.identifier == targetIdentifier }).first
    if let origin = origin, target = target {
      sprint("add link")
      let link = Link(origin: origin, target: target)
      link.editing = true
      links.append(link)
    }
  }
  
  func addLinkView(link: Link) {
    if !link.added {
      sprint("add link view")
      let linkView = LinkView(frame: link.rect, link: link, canvas: self)
      addSubview(linkView)
      link.added = true
    }
  }
  
  // MARK: - Dragging
  
  func moveConceptView(conceptView: ConceptView, theEvent: NSEvent) {
    let concept = conceptView.concept
    concept.point = convertPoint(theEvent.locationInWindow, fromView: nil)
    conceptView.frame = conceptRectWithOffset(concept)
    
    // modify link views
    let affectedLinks = links.filter { return $0.origin == concept || $0.target == concept }
    let affectedLinkViews = subviews
      .filter { return ($0 as? LinkView) != nil }
      .filter { return affectedLinks.contains(($0 as! LinkView).link) }
    
    for linkView in (affectedLinkViews as! [LinkView]) {
      linkView.frame = linkView.link.rect
    }
  }
  
  // MARK: - Concept functions
  
  func addConceptView(concept: Concept) {
    if !concept.added {
      sprint("add concept \(concept.identifier)")
      let conceptRect = conceptRectWithOffset(concept)
      let conceptView = ConceptView(
        frame: conceptRect,
        concept: concept,
        canvas: self
      )
      concept.added = true
      addSubview(conceptView)
    }
  }
  
  let offsetX: CGFloat = 80.0
  let offsetY: CGFloat = 40.0
  func conceptRectWithOffset(concept: Concept) -> NSRect {
    let size = concept.stringValue.sizeWithAttributes(nil)
    let bigSize = NSMakeSize(size.width + offsetX, size.height + offsetY)
    return NSRect(center: concept.point, size: bigSize)
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
    Swift.print("\(self.className): \(message)")
  }
}
