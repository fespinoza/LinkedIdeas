//
//  NSPoint+Utilities.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 11/12/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSPoint {
  func translate(deltaX: CGFloat, deltaY: CGFloat) -> NSPoint {
    return NSPoint(x: x + deltaX, y: y + deltaY)
  }

  func distanceTo(_ otherPoint: NSPoint) -> CGFloat {
    return sqrt(pow(x - otherPoint.x, 2.0) + pow(y - otherPoint.y, 2.0))
  }

  func description() -> String {
    return "(\(x), \(y))"
  }
}
