//
//  CanvasView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol DrawableElement {
  func draw()
}

protocol CanvasViewDataSource {
  var drawableElements: [DrawableElement] { get }
}

class CanvasView: NSView {
  
  var dataSource: CanvasViewDataSource?

  var selectFromPoint: NSPoint? = nil
  var selectToPoint: NSPoint? = nil
  var selectionRect: NSRect? {
    if let selectFromPoint = selectFromPoint, let selectToPoint = selectToPoint {
      return NSRect(p1: selectFromPoint, p2: selectToPoint)
    } else {
      return nil
    }
  }
  
  override var acceptsFirstResponder: Bool { return true }

  var arrowStartPoint: NSPoint? = nil
  var arrowEndPoint: NSPoint? = nil
  var arrowColor: NSColor? = nil

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    drawBackground()
    
    if let dataSource = dataSource {
      for element in dataSource.drawableElements { element.draw() }
    }
    
    drawSelectionRect()

    drawLinkConstructionArrow()
  }
  
  func drawBackground() {
    NSColor.white.set()
    NSRectFill(bounds)
  }
  
  func drawSelectionRect() {
    guard let selectionRect = selectionRect else { return }
    
    let borderColor = NSColor(red: 0, green: 0, blue: 1, alpha: 1)
    let backgroundColor = NSColor(red: 0, green: 0, blue: 1, alpha: 0.5)
    
    let bezierPath = NSBezierPath(rect: selectionRect)
    
    borderColor.set()
    bezierPath.stroke()
    
    backgroundColor.set()
    bezierPath.fill()
  }

  func drawLinkConstructionArrow() {
    guard let arrowStartPoint = arrowStartPoint, let arrowEndPoint = arrowEndPoint else {
      return
    }
    
    let arrow = Arrow(p1: arrowStartPoint, p2: arrowEndPoint)

    if let arrowColor = arrowColor {
      arrowColor.set()
    } else {
      NSColor.blue.set()
    }
    
    arrow.bezierPath().stroke()
  }
  
  override func keyDown(with event: NSEvent) {
    super.keyDown(with: event)
  }
}
