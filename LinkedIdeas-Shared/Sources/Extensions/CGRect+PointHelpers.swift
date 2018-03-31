//
//  CGRect+PointHelpers.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/12/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import CoreGraphics

public extension CGRect {
  init(point1: CGPoint, point2: CGPoint) {
    let origin = CGPoint(x: min(point1.x, point2.x), y: min(point1.y, point2.y))
    let size = CGSize(width: abs(point2.x - point1.x), height: abs(point2.y - point1.y))

    self.init(origin: origin, size: size)
  }

  init(center: CGPoint, size: CGSize) {
    let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
    self.init(origin: origin, size: size)
  }

  var bottomLeftPoint: CGPoint { return origin }
  var bottomRightPoint: CGPoint { return CGPoint(x: origin.x + size.width, y: origin.y) }
  var topRightPoint: CGPoint { return CGPoint(x: origin.x + size.width, y: origin.y + size.height) }
  var topLeftPoint: CGPoint { return CGPoint(x: origin.x, y: origin.y + size.height) }
  var middleLeftPoint: CGPoint { return CGPoint(x: origin.x, y: center.y) }
  var middleRightPoint: CGPoint { return CGPoint(x: origin.x + size.width, y: center.y) }
  var center: CGPoint { return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2) }
}
