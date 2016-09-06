//
//  LinkView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class LinkView: NSView, CanvasElement, ArrowDrawable, ClickableView, LinkViewActions, HoveringView {
  // own
  var link: Link
  var arrowPath: NSBezierPath? { return constructArrow()?.bezierPath() }
  
  // MARK: - HoveringView
  var isHoveringView: Bool = false {
    didSet { needsDisplay = true }
  }
  
  // CanvasElement
  var canvas: OldCanvasView
  
  override var description: String {
    return "[LinkView][\(link.identifier)]"
  }
  
  init(link: Link, canvas: OldCanvasView) {
    self.link = link
    self.canvas = canvas
    super.init(frame: link.rect)
    enableTrackingArea()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - NSResponder
  
  override var acceptsFirstResponder: Bool { return true }
  
  // MARK: - NSView
  
  override func draw(_ dirtyRect: NSRect) {
    drawArrow()
    if (link.isSelected) { drawArrowBorder() }
    drawHoveringState()
  }
  
  // MARK: - ArrowDrawable
  
  func constructArrow() -> Arrow? {
    let originPoint = link.originPoint
    let targetPoint = link.targetPoint
    
    let originRect = canvas.conceptViewFor(link.origin).frame
    let targetRect = canvas.conceptViewFor(link.target).frame
    
    if let intersectionPointWithOrigin = originRect.firstIntersectionTo(targetPoint), let intersectionPointWithTarget = targetRect.firstIntersectionTo(originPoint) {
      let intersectionPointWithOriginInLinkViewCoordinates = convert(intersectionPointWithOrigin, from: canvas)
      let intersectionPointWithTargetInLinkViewCoordinates = convert(intersectionPointWithTarget, from: canvas)
      
      return Arrow(p1: intersectionPointWithOriginInLinkViewCoordinates, p2: intersectionPointWithTargetInLinkViewCoordinates)
    } else {
      return nil
    }
  }
  
  func drawArrow() {
    link.color.set()
    arrowPath?.fill()
  }
  
  func drawArrowBorder() {
    NSColor.black.set()
    arrowPath?.stroke()
  }
  
  // MARK: - Mouse Events
  
  override func mouseDown(with theEvent: NSEvent) {
    let point = convert(theEvent.locationInWindow, from: nil)
    if let arrowPath = arrowPath, arrowPath.contains(point) {
      click(point)
    } else {
      super.mouseDown(with: theEvent)
    }
  }
  
  override func mouseEntered(with theEvent: NSEvent) {
    isHoveringView = true
    super.mouseEntered(with: theEvent)
  }
  
  override func mouseExited(with theEvent: NSEvent) {
    isHoveringView = false
    super.mouseExited(with: theEvent)
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
  
  // MARK: - ClickableView
  
  func click(_ point: NSPoint) {
    canvas.unselectConcepts()
    canvas.unselectLinks()
    selectLink()
//    (window?.windowController as? WindowController)?.selectedColor = link.color
  }
  
  func doubleClick(_ point: NSPoint) {}
  
  // MARK: - LinkViewActions
  
  func selectLink() {
    link.isSelected = true
    becomeFirstResponder()
    needsDisplay = true
  }
  
  func pressDeleteKey() {
    canvas.removeLinkView(self)
  }
}
