//
//  NSView+Debugging.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/12/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSView {
  var area: CGFloat { return 8 }
   
  func drawDotAtPoint(point: NSPoint) {
    NSColor.redColor().set()
    var x: CGFloat = point.x
    var y: CGFloat = point.y
    
    if x >= bounds.maxX { x = bounds.maxX - area }
    if y >= bounds.maxY { y = bounds.maxY - area }
    
    let rect = NSMakeRect(x, y, area, area)
    NSBezierPath(ovalInRect: rect).fill()
  }
  
  func drawCenteredDotAtPoint(point: NSPoint, color: NSColor = NSColor.yellowColor()) {
    color.set()
    var x: CGFloat = point.x - area / 2
    var y: CGFloat = point.y - area / 2
    
    if x >= bounds.maxX { x = bounds.maxX - area / 2 }
    if y >= bounds.maxY { y = bounds.maxY - area / 2 }
    
    let rect = NSMakeRect(x, y, area, area)
    NSBezierPath(ovalInRect: rect).fill()
    
  }
  
  func drawBorderForRect(rect: NSRect) {
    NSColor.blueColor().set()
    let border = NSBezierPath()
    border.moveToPoint(rect.bottomLeftPoint)
    border.lineToPoint(rect.bottomRightPoint)
    border.lineToPoint(rect.topRightPoint)
    border.lineToPoint(rect.topLeftPoint)
    border.lineToPoint(rect.bottomLeftPoint)
    border.stroke()
  }
  
  func drawFullRect(rect: NSRect) {
    NSRectFill(rect)
    drawBorderForRect(rect)
    drawCenteredDotAtPoint(rect.origin, color: NSColor.redColor())
    drawCenteredDotAtPoint(rect.center)
  }
}