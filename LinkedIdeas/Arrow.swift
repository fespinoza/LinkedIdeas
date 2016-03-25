//
//  ArrowPath.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct Arrow {
  var p1: NSPoint
  var p2: NSPoint
  let arrowHeight: CGFloat = 20
  let arrowWidth: CGFloat = 15
  let arrowBodyWidth: CGFloat = 5

  func bezierPath() -> NSBezierPath {
    let B: CGFloat = arrowWidth / 2
    let C: CGFloat = arrowBodyWidth / 2
    let m = (p2.y - p1.y) / (p2.x - p1.x)
    let alpha = atan(m)
    let direction: CGFloat = p2.x >= p1.x ? 1 : -1

    let p5 = NSMakePoint((p2.x - direction * cos(alpha) * arrowHeight), (p2.y - direction * sin(alpha) * arrowHeight))
    let p3 = NSMakePoint((p5.x - B * sin(alpha)), (p5.y + B * cos(alpha)))
    let p4 = NSMakePoint((p5.x + B * sin(alpha)), (p5.y - B * cos(alpha)))

    // Arrow body
    let p6 = NSMakePoint((p5.x - C * sin(alpha)), (p5.y + C * cos(alpha)))
    let p7 = NSMakePoint((p5.x + C * sin(alpha)), (p5.y - C * cos(alpha)))
    let p8 = NSMakePoint((p1.x - C * sin(alpha)), (p1.y + C * cos(alpha)))
    let p9 = NSMakePoint((p1.x + C * sin(alpha)), (p1.y - C * cos(alpha)))

    let arrowPath = NSBezierPath()
    arrowPath.moveToPoint(p1)
    arrowPath.lineToPoint(p8)
    arrowPath.lineToPoint(p6)
    arrowPath.lineToPoint(p3)
    arrowPath.lineToPoint(p2)
    arrowPath.lineToPoint(p4)
    arrowPath.lineToPoint(p7)
    arrowPath.lineToPoint(p9)
    arrowPath.closePath()

    return arrowPath
  }
}
