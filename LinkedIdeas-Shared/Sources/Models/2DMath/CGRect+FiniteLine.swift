//
//  CGRect+FiniteLine.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 04/02/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import CoreGraphics

public extension CGRect {
  var lines: [FiniteLine] {
    var result: [FiniteLine] = []

    result.append(FiniteLine(point1: bottomLeftPoint, point2: bottomRightPoint))
    result.append(FiniteLine(point1: bottomRightPoint, point2: topRightPoint))
    result.append(FiniteLine(point1: topRightPoint, point2: topLeftPoint))
    result.append(FiniteLine(point1: topLeftPoint, point2: bottomLeftPoint))

    return result
  }

  public func intersectionTo(_ point: CGPoint) -> [CGPoint] {
    let secondLine = FiniteLine(point1: center, point2: point)
    return lines.map {
      $0.intersectionPointWith(secondLine)
      }.filter { $0 != nil }.map { $0! }
  }

  public func firstIntersectionTo(_ point: CGPoint) -> CGPoint? {
    return intersectionTo(point).first
  }

}
