//
//  CGRect+Extensions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit

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

