//
//  Concept.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

class Concept: NSObject, NSCoding, Element, VisualElement, AttributedStringElement {
  // NOTE: the point value is relative to the canvas coordinate system
  var point: NSPoint
  // element
  var identifier: String
  // MARK: - AttributedStringElement
  var attributedStringValue: NSAttributedString
  var stringValue: String { return attributedStringValue.string }
  
  static let padding: CGFloat = 10
  var minimalRect: NSRect {
    if stringValue != "" {
      var size = attributedStringValue.size()
      size.width  += Concept.padding
      size.height += Concept.padding
      return NSRect(center: point, size: size)
    } else {
      return NSRect(center: point, size: NSMakeSize(60, 20))
    }
  }
  // visual element
  var isEditable: Bool = false
  var isSelected: Bool = false

  // NSCoding
  let attributedStringValueKey = "stringValueKey"
  let pointKey = "pointKey"
  let identifierKey = "identifierKey"
  let isEditableKey = "isEditableKey"

  override var description: String {
    return "[\(identifier)] '\(stringValue)' \(isEditable) \(point)"
  }

  convenience init(point: NSPoint) {
    self.init(stringValue: "", point: point)
  }
  
  convenience init(stringValue: String, point: NSPoint) {
    self.init(attributedStringValue: NSAttributedString(string: stringValue), point: point)
  }

  init(attributedStringValue: NSAttributedString, point: NSPoint) {
    self.point = point
    self.identifier = "\(NSUUID().UUIDString)-concept"
    self.attributedStringValue = attributedStringValue
  }

  // MARK: - NSCoding

  required init?(coder aDecoder: NSCoder) {
    point       = aDecoder.decodePointForKey(pointKey)
    identifier  = aDecoder.decodeObjectForKey(identifierKey) as! String
    isEditable  = aDecoder.decodeBoolForKey(isEditableKey)
    attributedStringValue = aDecoder.decodeObjectForKey(attributedStringValueKey) as! NSAttributedString
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodePoint(point, forKey: pointKey)
    aCoder.encodeObject(attributedStringValue, forKey: attributedStringValueKey)
    aCoder.encodeObject(identifier, forKey: identifierKey)
    aCoder.encodeBool(isEditable, forKey: isEditableKey)
  }
}
