//
//  NSRect+PointHelpers.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/12/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSRect {
  init(p1: NSPoint, p2: NSPoint) {
    origin = NSMakePoint(min(p1.x, p2.x), min(p1.y, p2.y))
    size = NSSize(width:  abs(p2.x - p1.x), height: abs(p2.y - p1.y))
  }
  
  var bottomLeftPoint: NSPoint { return origin }
  var bottomRightPoint: NSPoint { return NSMakePoint(origin.x + size.width, origin.y) }
  var topRightPoint: NSPoint { return NSMakePoint(origin.x + size.width, origin.y + size.height) }
  var topLeftPoint: NSPoint { return NSMakePoint(origin.x, origin.y + size.height) }
  var center: NSPoint { return NSMakePoint(origin.x + size.width / 2, origin.y + size.height / 2) }
  
  var maxX: CGFloat { return origin.x + size.width }
  var maxY: CGFloat { return origin.x + size.width }
}