//
//  Concept.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

class Concept {
  var stringValue: String = "Insert Concpet"
  var point: NSPoint
  var added: Bool = false
  var editing: Bool = false
  var identifier = random()
  var rect: NSRect {
    let offset: CGFloat = 20.0
    let size = stringValue.sizeWithAttributes(nil)
    let x = self.point.x - size.width / 2.0 - offset
    let y = self.point.y - size.height / 2.0 - offset
    let point = NSPoint(x: x, y: y)
    let bigSize = NSSize(width: size.width + offset, height: size.height + offset)
    return NSRect(origin: point, size: bigSize)
  }
  
  init(point: NSPoint) {
    self.point = point
  }
  
  func draw() {
    stringValue.drawAtPoint(rect.origin, withAttributes: nil)
  }
  
}