//
//  ArrowPath.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import CoreGraphics

public struct Arrow {
  var point1: CGPoint
  var point2: CGPoint
  let arrowHeight: CGFloat = 20
  let arrowWidth: CGFloat = 15
  let arrowBodyWidth: CGFloat

  public init(point1: CGPoint, point2: CGPoint) {
    self.point1 = point1
    self.point2 = point2
    self.arrowBodyWidth = 5
  }

  public init(point1: CGPoint, point2: CGPoint, arrowBodyWidth: CGFloat = 5) {
    self.point1 = point1
    self.point2 = point2
    self.arrowBodyWidth = arrowBodyWidth
  }

  private var pendant: CGFloat { return (point2.y - point1.y) / (point2.x - point1.x) }
  private var sideC: CGFloat { return arrowBodyWidth / 2 }
  private var sideB: CGFloat { return arrowWidth / 2 }
  private var alpha: CGFloat { return atan(pendant) }
  private var direction: CGFloat { return point2.x >= point1.x ? 1 : -1 }

  private var point5: CGPoint {
    return CGPoint(x: (point2.x - direction * cos(alpha) * arrowHeight),
                   y: (point2.y - direction * sin(alpha) * arrowHeight))
  }
  private var point3: CGPoint { return CGPoint(x: (point5.x - sideB * sin(alpha)), y: (point5.y + sideB * cos(alpha))) }
  private var point4: CGPoint { return CGPoint(x: (point5.x + sideB * sin(alpha)), y: (point5.y - sideB * cos(alpha))) }
  private var point6: CGPoint { return CGPoint(x: (point5.x - sideC * sin(alpha)), y: (point5.y + sideC * cos(alpha))) }
  private var point7: CGPoint { return CGPoint(x: (point5.x + sideC * sin(alpha)), y: (point5.y - sideC * cos(alpha))) }
  private var point8: CGPoint { return CGPoint(x: (point1.x - sideC * sin(alpha)), y: (point1.y + sideC * cos(alpha))) }
  private var point9: CGPoint { return CGPoint(x: (point1.x + sideC * sin(alpha)), y: (point1.y - sideC * cos(alpha))) }

  public func arrowBodyPoints() -> [CGPoint] {
    return [point6, point7, point8, point9]
  }

  public func bezierPath() -> BezierPath {
    let arrowPath = BezierPath()
    arrowPath.move(to: point1)
    arrowPath.line(to: point8)
    arrowPath.line(to: point6)
    arrowPath.line(to: point3)
    arrowPath.line(to: point2)
    arrowPath.line(to: point4)
    arrowPath.line(to: point7)
    arrowPath.line(to: point9)
    arrowPath.close()

    return arrowPath
  }
}
