//
//  Concept.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class Concept: NSObject, NSCoding, Element, VisualElement, AttributedStringElement, SquareElement {
  static var areaManager: AreaManagerProtocol = AreaManager()

  // NOTE: the point value is relative to the canvas coordinate system
  var point: NSPoint

  var rect: NSRect {
    return Concept.areaManager.boundedRect(forAttributedString: attributedStringValue, atPoint: point)
  }

  // element
  var identifier: String

  // MARK: - NSAttributedStringElement
  dynamic var attributedStringValue: NSAttributedString
  var stringValue: String { return attributedStringValue.string }

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

  // Moving
  var beforeMovingPoint: NSPoint?

  override var description: String {
    return "[\(identifier)] '\(stringValue)' \(isEditable) \(point)"
  }

  convenience init(point: NSPoint) {
    self.init(stringValue: "", point: point)
  }

  convenience init(stringValue: String, point: NSPoint) {
    self.init(attributedStringValue:NSAttributedString(string: stringValue), point: point)
  }

  init(attributedStringValue: NSAttributedString, point: NSPoint) {
    self.point = point
    self.identifier = "\(UUID().uuidString)-concept"
    self.attributedStringValue = attributedStringValue
  }

  func contains(point: NSPoint) -> Bool {
    return rect.contains(point)
  }

  // MARK: - NSCoding

  required init?(coder aDecoder: NSCoder) {
    guard let identifier = aDecoder.decodeObject(forKey: Concept.identifierKey) as? String,
          let attributedStringValue = aDecoder.decodeObject(
            forKey: Concept.attributedStringValueKey
          ) as? NSAttributedString
      else {
        return nil
    }
    self.identifier = identifier
    self.attributedStringValue = attributedStringValue
    point = aDecoder.decodePoint(forKey: Concept.pointKey)
    isEditable = aDecoder.decodeBool(forKey: Concept.isEditableKey)
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(point, forKey: Concept.pointKey)
    aCoder.encode(attributedStringValue, forKey: Concept.attributedStringValueKey)
    aCoder.encode(identifier, forKey: Concept.identifierKey)
    aCoder.encode(isEditable, forKey: Concept.isEditableKey)
  }
}
