//
//  <.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

class Link {
  var origin: Concept
  var target: Concept
  var stringValue: String?
  var originPoint: NSPoint { return origin.point }
  var targetPoint: NSPoint { return target.point }
  var rect: NSRect { return NSRect(p1: originPoint, p2: targetPoint) }
  var added: Bool
  
  init(origin: Concept, target: Concept) {
    self.origin = origin
    self.target = target
    self.added  = false
  }
  
  func description() -> String {
    if let stringValue = stringValue {
      return "\(origin.stringValue) \(stringValue) \(target.stringValue)"
    } else {
      return "\(origin.stringValue) - \(target.stringValue)"
    }
  }
}