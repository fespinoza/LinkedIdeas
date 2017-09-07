//
//  NSRect+PointHelpers.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/12/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSRect {
  init(point1: NSPoint, point2: NSPoint) {
    origin = NSPoint(x: min(point1.x, point2.x), y: min(point1.y, point2.y))
    size = NSSize(width:  abs(point2.x - point1.x), height: abs(point2.y - point1.y))
  }

  init(center: NSPoint, size: NSSize) {
    origin = NSPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
    self.size = size
  }

  var bottomLeftPoint: NSPoint { return origin }
  var bottomRightPoint: NSPoint { return NSPoint(x: origin.x + size.width, y: origin.y) }
  var topRightPoint: NSPoint { return NSPoint(x: origin.x + size.width, y: origin.y + size.height) }
  var topLeftPoint: NSPoint { return NSPoint(x: origin.x, y: origin.y + size.height) }
  var middleLeftPoint: NSPoint { return NSPoint(x: origin.x, y: center.y) }
  var middleRightPoint: NSPoint { return NSPoint(x: origin.x + size.width, y: center.y) }
  var center: NSPoint { return NSPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2) }
}

extension NSRect {
  var lines: [FiniteLine] {
    var result: [FiniteLine] = []

    result.append(FiniteLine(point1: bottomLeftPoint, point2: bottomRightPoint))
    result.append(FiniteLine(point1: bottomRightPoint, point2: topRightPoint))
    result.append(FiniteLine(point1: topRightPoint, point2: topLeftPoint))
    result.append(FiniteLine(point1: topLeftPoint, point2: bottomLeftPoint))

    return result
  }

  func intersectionTo(_ point: NSPoint) -> [NSPoint] {
    let secondLine = FiniteLine(point1: center, point2: point)
    return lines.map {
      $0.intersectionPointWith(secondLine)
      }.filter { $0 != nil }.map { $0! }
  }

  func firstIntersectionTo(_ point: NSPoint) -> NSPoint? {
    return intersectionTo(point).first
  }

}
