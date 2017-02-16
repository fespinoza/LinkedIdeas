//
//  FiniteLine.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct FiniteLine: Interceptable, PointInterceptable {
  var p1: NSPoint
  var p2: NSPoint

  var line: Line {
    return Line(p1: p1, p2: p2)
  }

  var lineRange: LineRange {
    return LineRange(
      minX: min(p1.x, p2.x),
      maxX: max(p1.x, p2.x),
      minY: min(p1.y, p2.y),
      maxY: max(p1.y, p2.y)
    )
  }

  func interceptsWith(_ other: FiniteLine) -> Bool {
    return lineRange.interceptsWith(other.lineRange)
  }

  func bezierPath() -> NSBezierPath {
    let path = NSBezierPath()
    path.move(to: p1)
    path.line(to: p2)
    return path
  }

  func intersectionPointWith(_ other: FiniteLine) -> NSPoint? {
    if let intersectionPoint = line.intersectionPointWith(other.line) {
      let intersectionLineRange = lineRange.interception(other.lineRange)
      if (intersectionLineRange.isValid() && intersectionLineRange.doesContain(intersectionPoint)) {
        return intersectionPoint
      }
    }
    return nil
  }
}
