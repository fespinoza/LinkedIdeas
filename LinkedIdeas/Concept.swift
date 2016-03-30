//
//  Concept.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

class Concept: NSObject, NSCoding, Element, VisualElement, StringElement {
  // NOTE: the point value is relative to the canvas coordinate system
  var point: NSPoint
  // element
  var identifier: String
  var stringValue: String
  
  private let padding: CGFloat = 10
  var minimalRect: NSRect {
    if stringValue != "" {
      var size = stringValue.sizeWithAttributes(nil)
      size.width  += padding
      size.height += padding
      return NSRect(center: point, size: size)
    } else {
      return NSRect(center: point, size: NSMakeSize(60, 20))
    }
  }
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
    self.identifier = "\(NSUUID().UUIDString)-concept"
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
