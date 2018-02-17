//
//  Line.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import CoreGraphics

public struct Line: PointInterceptable {
  var pointA: CGPoint
  var pointB: CGPoint

  public init(pointA: CGPoint, pointB: CGPoint) {
    self.pointA = pointA
    self.pointB = pointB
  }

  var gradient: CGFloat {
    return (pointB.y - pointA.y) / (pointB.x - pointA.x)
  }
  var intersectionWithYAxis: CGFloat {
    if isConstantLineOnY() {
      return pointA.y
    }
    return pointA.y - pointA.x * gradient
  }

  var intersectionWithXAxis: CGFloat {
    if isConstantLineOnX() {
      return pointA.x
    }
    return -intersectionWithYAxis / gradient
  }

  func evaluateX(_ xPoint: CGFloat) -> CGFloat {
    return gradient * xPoint + intersectionWithYAxis
  }

  func evaluateY(_ yPoint: CGFloat) -> CGFloat {
    return (yPoint - intersectionWithYAxis) / gradient
  }

  func isConstantLineOnX() -> Bool {
    return gradient.isInfinite
  }

  func isConstantLineOnY() -> Bool {
    return gradient == 0
  }

  func isParallelTo(_ line: Line) -> Bool {
    return abs(gradient) == abs(line.gradient)
  }

  var description: String {
    return "L(x) = \(gradient)*x + \(intersectionWithYAxis)"
  }

  // it does not considate the same lines: the answer is all the points
  public func intersectionPointWith(_ line: Line) -> CGPoint? {
    if isParallelTo(line) {
      return nil
    }

    if line.isConstantLineOnX() {
      let intersectionX = line.intersectionWithXAxis
      let intersectionY = evaluateX(intersectionX)
      return CGPoint(x: intersectionX, y: intersectionY)
    }
    if isConstantLineOnX() {
      let intersectionX = intersectionWithXAxis
      let intersectionY = line.evaluateX(intersectionX)
      return CGPoint(x: intersectionX, y: intersectionY)
    }

    let intersectionX: CGFloat = (line.intersectionWithYAxis - intersectionWithYAxis) / (gradient - line.gradient)
    let intersectionY: CGFloat = evaluateX(intersectionX)
    return CGPoint(x: intersectionX, y: intersectionY)
  }

  public func intersectionPointWithinBoundaries(
    _ line: Line, lineBoundaryP1 point1: CGPoint, lineBoundaryP2 point2: CGPoint
  ) -> CGPoint? {
    return nil
  }
}
