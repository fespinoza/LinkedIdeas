//
//  CGRect+PointHelpers.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/12/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension CGRect {
  init(point1: CGPoint, point2: CGPoint) {
    origin = CGPoint(x: min(point1.x, point2.x), y: min(point1.y, point2.y))
    size = CGSize(width: abs(point2.x - point1.x), height: abs(point2.y - point1.y))
  }

  init(center: CGPoint, size: CGSize) {
    origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
    self.size = size
  }

  var bottomLeftPoint: CGPoint { return origin }
  var bottomRightPoint: CGPoint { return CGPoint(x: origin.x + size.width, y: origin.y) }
  var topRightPoint: CGPoint { return CGPoint(x: origin.x + size.width, y: origin.y + size.height) }
  var topLeftPoint: CGPoint { return CGPoint(x: origin.x, y: origin.y + size.height) }
  var middleLeftPoint: CGPoint { return CGPoint(x: origin.x, y: center.y) }
  var middleRightPoint: CGPoint { return CGPoint(x: origin.x + size.width, y: center.y) }
  var center: CGPoint { return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2) }
}

extension CGRect {
  var lines: [FiniteLine] {
    var result: [FiniteLine] = []

    result.append(FiniteLine(point1: bottomLeftPoint, point2: bottomRightPoint))
    result.append(FiniteLine(point1: bottomRightPoint, point2: topRightPoint))
    result.append(FiniteLine(point1: topRightPoint, point2: topLeftPoint))
    result.append(FiniteLine(point1: topLeftPoint, point2: bottomLeftPoint))

    return result
  }

  func intersectionTo(_ point: CGPoint) -> [CGPoint] {
    let secondLine = FiniteLine(point1: center, point2: point)
    return lines.map {
      $0.intersectionPointWith(secondLine)
      }.filter { $0 != nil }.map { $0! }
  }

  func firstIntersectionTo(_ point: CGPoint) -> CGPoint? {
    return intersectionTo(point).first
  }

}
