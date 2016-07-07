//
//  Concept.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class Concept: NSObject, NSCoding, Element, VisualElement, AttributedStringElement, SquareElement {
  // NOTE: the point value is relative to the canvas coordinate system
  var point: NSPoint
  // element
  var identifier: String
  // MARK: - AttributedStringElement
  dynamic var attributedStringValue: NSAttributedString
  var stringValue: String { return attributedStringValue.string }
  
  static let padding: CGFloat = 10
  var rect: NSRect {
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
  
  // KVO
  static let attributedStringValuePath = "attributedStringValue"
  static let pointPath = "point"
  static let identifierPath = "identifier"
  static let isEditablePath = "isEditable"

  // NSCoding
  static let attributedStringValueKey = "stringValueKey"
  static let pointKey = "pointKey"
  static let identifierKey = "identifierKey"
  static let isEditableKey = "isEditableKey"

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
    point       = aDecoder.decodePointForKey(Concept.pointKey)
    identifier  = aDecoder.decodeObjectForKey(Concept.identifierKey) as! String
    isEditable  = aDecoder.decodeBoolForKey(Concept.isEditableKey)
    attributedStringValue = aDecoder.decodeObjectForKey(Concept.attributedStringValueKey) as! NSAttributedString
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodePoint(point, forKey: Concept.pointKey)
    aCoder.encodeObject(attributedStringValue, forKey: Concept.attributedStringValueKey)
    aCoder.encodeObject(identifier, forKey: Concept.identifierKey)
    aCoder.encodeBool(isEditable, forKey: Concept.isEditableKey)
  }
}
