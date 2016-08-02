//
//  NSRect+PointHelpers.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/12/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSRect {
  init(p1: NSPoint, p2: NSPoint) {
    origin = NSMakePoint(min(p1.x, p2.x), min(p1.y, p2.y))
    size = NSSize(width:  abs(p2.x - p1.x), height: abs(p2.y - p1.y))
  }
  
  init(center: NSPoint, size: NSSize) {
    origin = NSMakePoint(center.x - size.width / 2, center.y - size.height / 2)
    self.size = size
  }
  
  var bottomLeftPoint: NSPoint { return origin }
  var bottomRightPoint: NSPoint { return NSMakePoint(origin.x + size.width, origin.y) }
  var topRightPoint: NSPoint { return NSMakePoint(origin.x + size.width, origin.y + size.height) }
  var topLeftPoint: NSPoint { return NSMakePoint(origin.x, origin.y + size.height) }
  var center: NSPoint { return NSMakePoint(origin.x + size.width / 2, origin.y + size.height / 2) }
  
  var maxX: CGFloat { return origin.x + size.width }
  var maxY: CGFloat { return origin.y + size.height }
  
  var lines: [FiniteLine] {
    var result: [FiniteLine] = []
    
    result.append(FiniteLine(p1: bottomLeftPoint, p2: bottomRightPoint))
    result.append(FiniteLine(p1: bottomRightPoint, p2: topRightPoint))
    result.append(FiniteLine(p1: topRightPoint, p2: topLeftPoint))
    result.append(FiniteLine(p1: topLeftPoint, p2: bottomLeftPoint))
    
    return result
  }
  
  func intersectionTo(_ point: NSPoint) -> [NSPoint] {
    let secondLine = FiniteLine(p1: center, p2: point)
    return lines.map {
      $0.intersectionPointWith(secondLine)
    }.filter { $0 != nil }.map { $0! }
  }
  
  func firstIntersectionTo(_ point: NSPoint) -> NSPoint? {
    return intersectionTo(point).first
  }
}
