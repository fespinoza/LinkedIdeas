//
//  Line.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

struct Line: PointInterceptable {
  var p1: NSPoint
  var p2: NSPoint
  
  var gradient: CGFloat {
    return (p2.y - p1.y) / (p2.x - p1.x)
  }
  var intersectionWithYAxis: CGFloat {
    if (isConstantLineOnY()) { return p1.y }
    return p1.y - p1.x * gradient
  }
  
  var intersectionWithXAxis: CGFloat {
    if (isConstantLineOnX()) { return p1.x }
    return -intersectionWithYAxis / gradient
  }
  
  func evaluateX(_ x: CGFloat) -> CGFloat {
    return gradient * x + intersectionWithYAxis
  }
  
  func evaluateY(_ y: CGFloat) -> CGFloat {
    return (y - intersectionWithYAxis) / gradient
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
  func intersectionPointWith(_ line: Line) -> NSPoint? {
    if (isParallelTo(line)) {
      return nil
    }
    
    if (line.isConstantLineOnX()) {
      let intersectionX = line.intersectionWithXAxis
      let intersectionY = evaluateX(intersectionX)
      return NSMakePoint(intersectionX, intersectionY)
    }
    if (isConstantLineOnX()) {
      let intersectionX = intersectionWithXAxis
      let intersectionY = line.evaluateX(intersectionX)
      return NSMakePoint(intersectionX, intersectionY)
    }
    
    let intersectionX: CGFloat = (line.intersectionWithYAxis - intersectionWithYAxis) / (gradient - line.gradient)
    let intersectionY: CGFloat = evaluateX(intersectionX)
    return NSMakePoint(intersectionX, intersectionY)
  }
  
  func intersectionPointWithinBoundaries(_ line: Line, lineBoundaryP1 p1: NSPoint, lineBoundaryP2 p2: NSPoint) -> NSPoint? {
    return nil
  }
}
