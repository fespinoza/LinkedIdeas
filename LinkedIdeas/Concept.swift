//
//  Concept.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol Element {
  var identifier: String { get }
  var stringValue: String { get  set }
  var minimalRect: NSRect { get }
}

protocol VisualElement {
  var isEditable: Bool { get set }
  var isSelected: Bool { get set }
}

class Concept: NSObject, NSCoding, Element, VisualElement {
  var point: NSPoint
  // element
  var identifier: String
  var stringValue: String
  var minimalRect: NSRect { return NSRect(center: point, size: NSMakeSize(60, 20)) }
  // visual element
  var isEditable: Bool = false
  var isSelected: Bool = false

  // NSCoding
  let stringValueKey = "stringValueKey"
  let pointKey = "pointKey"
  let identifierKey = "identifierKey"
  let isEditableKey = "isEditableKey"

  override var description: String {
    return "[\(identifier)] '\(stringValue)' \(isEditable) \(point)"
  }

  convenience init(point: NSPoint) {
    self.init(stringValue: "", point: point)
  }

  init(stringValue: String, point: NSPoint) {
    self.point = point
    self.identifier = "\(random())-concept"
    self.stringValue = stringValue
  }

  // MARK: - NSCoding

  required init?(coder aDecoder: NSCoder) {
    point       = aDecoder.decodePointForKey(pointKey)
    identifier  = aDecoder.decodeObjectForKey(identifierKey) as! String
    isEditable  = aDecoder.decodeBoolForKey(isEditableKey)
    stringValue = aDecoder.decodeObjectForKey(stringValueKey) as! String
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodePoint(point, forKey: pointKey)
    aCoder.encodeObject(stringValue, forKey: stringValueKey)
    aCoder.encodeObject(identifier, forKey: identifierKey)
    aCoder.encodeBool(isEditable, forKey: isEditableKey)
  }
}
