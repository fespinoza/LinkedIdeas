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
  let arrowBodyWidth: CGFloat

  init(p1: NSPoint, p2: NSPoint) {
    self.p1 = p1
    self.p2 = p2
    self.arrowBodyWidth = 5
  }

  init(p1: NSPoint, p2: NSPoint, arrowBodyWidth: CGFloat = 5) {
    self.p1 = p1
    self.p2 = p2
    self.arrowBodyWidth = arrowBodyWidth
  }

  private var m: CGFloat { return (p2.y - p1.y) / (p2.x - p1.x) }
  private var C: CGFloat { return arrowBodyWidth / 2 }
  private var B: CGFloat { return arrowWidth / 2 }
  private var alpha: CGFloat { return atan(m) }
  private var direction: CGFloat { return p2.x >= p1.x ? 1 : -1 }

  private var p5: NSPoint {
    return NSMakePoint((p2.x - direction * cos(alpha) * arrowHeight), (p2.y - direction * sin(alpha) * arrowHeight))
  }
  private var p3: NSPoint { return NSMakePoint((p5.x - B * sin(alpha)), (p5.y + B * cos(alpha))) }
  private var p4: NSPoint { return NSMakePoint((p5.x + B * sin(alpha)), (p5.y - B * cos(alpha))) }
  private var p6: NSPoint { return NSMakePoint((p5.x - C * sin(alpha)), (p5.y + C * cos(alpha))) }
  private var p7: NSPoint { return NSMakePoint((p5.x + C * sin(alpha)), (p5.y - C * cos(alpha))) }
  private var p8: NSPoint { return NSMakePoint((p1.x - C * sin(alpha)), (p1.y + C * cos(alpha))) }
  private var p9: NSPoint { return NSMakePoint((p1.x + C * sin(alpha)), (p1.y - C * cos(alpha))) }

  func arrowBodyPoints() -> [NSPoint] {
    return [p6, p7, p8, p9]
  }

  func bezierPath() -> NSBezierPath {
    let arrowPath = NSBezierPath()
    arrowPath.move(to: p1)
    arrowPath.line(to: p8)
    arrowPath.line(to: p6)
    arrowPath.line(to: p3)
    arrowPath.line(to: p2)
    arrowPath.line(to: p4)
    arrowPath.line(to: p7)
    arrowPath.line(to: p9)
    arrowPath.close()

    return arrowPath
  }
}
