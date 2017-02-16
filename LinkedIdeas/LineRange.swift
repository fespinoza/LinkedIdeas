//
//  LineRange.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

struct LineRange: Interceptable {
  var minX: CGFloat
  var maxX: CGFloat
  var minY: CGFloat
  var maxY: CGFloat

  func isValid() -> Bool {
    return minX <= maxX && minY <= maxY
  }

  func interceptsWith(_ other: LineRange) -> Bool {
    return interception(other).isValid()
  }

  func interception(_ other: LineRange) -> LineRange {
    return LineRange(
      minX: max(minX, other.minX),
      maxX: min(maxX, other.maxX),
      minY: max(minY, other.minY),
      maxY: min(maxY, other.maxY)
    )
  }

  func doesContain(_ point: NSPoint) -> Bool {
    return point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
  }
}
