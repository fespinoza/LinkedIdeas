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
  override var description: String {
    return "'\(origin.stringValue)' \(stringValue) '\(target.stringValue)'"
  }
  
  init(origin: Concept, target: Concept) {
    self.origin = origin
    self.target = target
    self.added  = false
  }
  
  let stringValueKey = "StringValueKey"
  let originKey = "OriginKey"
  let targetKey = "TargetKey"
  
  required init?(coder aDecoder: NSCoder) {
    stringValue = aDecoder.decodeObjectForKey(stringValueKey) as! String
    origin = aDecoder.decodeObjectForKey(originKey) as! Concept
    target = aDecoder.decodeObjectForKey(targetKey) as! Concept
    added = false
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(stringValue, forKey: stringValueKey)
    aCoder.encodeObject(origin, forKey: originKey)
    aCoder.encodeObject(target, forKey: targetKey)
  }
}