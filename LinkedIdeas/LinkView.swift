//
//  LinkView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol ArrowDrawable {
  func constructArrow() -> Arrow
  func drawArrow()
  func drawArrowBorder()
}

protocol LinkViewActions {
  func selectLink()
}

class LinkView: NSView, CanvasElement, ArrowDrawable, ClickableView, LinkViewActions {
  // own
  var link: Link
  
  // CanvasElement
  var canvas: CanvasView
  
  init(link: Link, canvas: CanvasView) {
    self.link = link
    self.canvas = canvas
    super.init(frame: link.minimalRect)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(dirtyRect: NSRect) {
    drawArrow()
    if (link.isSelected) { drawArrowBorder() }
  }
  
  // MARK: - ArrowDrawable
  
  func constructArrow() -> Arrow {
    let originPoint = link.originPoint
    let targetPoint = link.targetPoint
    
    let originRect = canvas.conceptViewFor(link.origin).frame
    let targetRect = canvas.conceptViewFor(link.target).frame
    
    let intersectionPointWithOrigin = originRect.firstIntersectionTo(targetPoint)!
    let intersectionPointWithTarget = targetRect.firstIntersectionTo(originPoint)!
    
    let intersectionPointWithOriginInLinkViewCoordinates = convertPoint(intersectionPointWithOrigin, fromView: canvas)
    let intersectionPointWithTargetInLinkViewCoordinates = convertPoint(intersectionPointWithTarget, fromView: canvas)
    
    return Arrow(p1: intersectionPointWithOriginInLinkViewCoordinates, p2: intersectionPointWithTargetInLinkViewCoordinates)
  }
  
  func drawArrow() {
    let arrowPath = constructArrow().bezierPath()
    NSColor.grayColor().set()
    arrowPath.fill()
  }
  
  func drawArrowBorder() {
    let arrowPath = constructArrow().bezierPath()
    NSColor.blackColor().set()
    arrowPath.stroke()
  }
  
  // MARK: - Mouse Events
  
  override func mouseDown(theEvent: NSEvent) {
    click(theEvent.locationInWindow)
  }
  
  // MARK: - ClickableView
  
  func click(point: NSPoint) {
    canvas.unselectConcepts()
    canvas.unselectLinks()
    selectLink()
  }
  
  func doubleClick(point: NSPoint) {}
  
  // MARK: - LinkViewActions
  
  func selectLink() {
    link.isSelected = true
    becomeFirstResponder()
    needsDisplay = true
  }
}
