//
//  <.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

class Link: NSObject, NSCoding {
  var origin: Concept
  var target: Concept
  var stringValue: String = ""
  var originPoint: NSPoint { return origin.point }
  var targetPoint: NSPoint { return target.point }
  var rect: NSRect { return NSRect(p1: originPoint, p2: targetPoint) }
  var added: Bool
  
  init(origin: Concept, target: Concept) {
    self.origin = origin
    self.target = target
    self.added  = false
  }
  
  let stringValueKey = "StringValueKey"
  required init?(coder aDecoder: NSCoder) {
    origin = Concept(coder: aDecoder)!
    target = Concept(coder: aDecoder)!
    stringValue = aDecoder.decodeObjectForKey(stringValueKey) as! String
    added = false
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(stringValue, forKey: stringValueKey)
    origin.encodeWithCoder(aCoder)
    target.encodeWithCoder(aCoder)
  }
}