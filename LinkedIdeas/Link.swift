//
//  <.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

class Link: NSObject, NSCoding, Element {
  // own attributes
  var origin: Concept
  var target: Concept
  var originPoint: NSPoint { return origin.point }
  var targetPoint: NSPoint { return target.point }
  
  override var description: String {
    return "'\(origin.stringValue)' '\(target.stringValue)'"
  }
  
  // Element
  var identifier: String
  var minimalRect: NSRect {
    return NSRect(p1: originPoint, p2: targetPoint)
  }
  
  init(origin: Concept, target: Concept) {
    self.origin = origin
    self.target = target
    self.identifier = "\(random())-link"
  }
  
  let identifierKey = "identifierKey"
  let originKey = "OriginKey"
  let targetKey = "TargetKey"
  
  required init?(coder aDecoder: NSCoder) {
    identifier = aDecoder.decodeObjectForKey(identifierKey) as! String
    origin = aDecoder.decodeObjectForKey(originKey) as! Concept
    target = aDecoder.decodeObjectForKey(targetKey) as! Concept
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(identifier, forKey: identifierKey)
    aCoder.encodeObject(origin, forKey: originKey)
    aCoder.encodeObject(target, forKey: targetKey)
  }
}