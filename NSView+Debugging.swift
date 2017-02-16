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

  func debugDrawing() {
    drawBorderForRect(bounds)
    drawCenteredDotAtPoint(bounds.center)
  }

  func drawDotAtPoint(_ point: NSPoint) {
    NSColor.red.set()
    var x: CGFloat = point.x
    var y: CGFloat = point.y

    if x >= bounds.maxX { x = bounds.maxX - area }
    if y >= bounds.maxY { y = bounds.maxY - area }

    let rect = NSRect(
      origin: NSPoint(x: x, y: y),
      size: NSSize(width: area, height: area)
    )
    NSBezierPath(ovalIn: rect).fill()
  }

  func drawCenteredDotAtPoint(_ point: NSPoint, color: NSColor = NSColor.yellow) {
    color.set()
    var x: CGFloat = point.x - area / 2
    var y: CGFloat = point.y - area / 2

    if x >= bounds.maxX { x = bounds.maxX - area / 2 }
    if y >= bounds.maxY { y = bounds.maxY - area / 2 }

    let rect = NSRect(
      origin: NSPoint(x: x, y: y),
      size: NSSize(width: area, height: area)
    )
    NSBezierPath(ovalIn: rect).fill()

  }

  func drawBorderForRect(_ rect: NSRect) {
    NSColor.blue.set()
    let border = NSBezierPath()
    border.move(to: rect.bottomLeftPoint)
    border.line(to: rect.bottomRightPoint)
    border.line(to: rect.topRightPoint)
    border.line(to: rect.topLeftPoint)
    border.line(to: rect.bottomLeftPoint)
    border.stroke()
  }

  func drawFullRect(_ rect: NSRect) {
    NSRectFill(rect)
    drawBorderForRect(rect)
    drawCenteredDotAtPoint(rect.origin, color: NSColor.red)
    drawCenteredDotAtPoint(rect.center)
  }
}
