//
//  FiniteLine.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct FiniteLine: Interceptable, PointInterceptable {
  var point1: NSPoint
  var point2: NSPoint

  var line: Line {
    return Line(pointA: point1, pointB: point2)
  }

  var lineRange: LineRange {
    return LineRange(
      minX: min(point1.x, point2.x),
      maxX: max(point1.x, point2.x),
      minY: min(point1.y, point2.y),
      maxY: max(point1.y, point2.y)
    )
  }

  func interceptsWith(_ other: FiniteLine) -> Bool {
    return lineRange.interceptsWith(other.lineRange)
  }

  func bezierPath() -> NSBezierPath {
    let path = NSBezierPath()
    path.move(to: point1)
    path.line(to: point2)
    return path
  }

  func intersectionPointWith(_ other: FiniteLine) -> NSPoint? {
    if let intersectionPoint = line.intersectionPointWith(other.line) {
      let intersectionLineRange = lineRange.interception(other.lineRange)
      if intersectionLineRange.isValid() && intersectionLineRange.doesContain(intersectionPoint) {
        return intersectionPoint
      }
    }
    return nil
  }
}
