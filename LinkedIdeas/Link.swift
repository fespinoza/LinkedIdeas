//
//  <.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class Link: NSObject, NSCoding, Element, VisualElement, AttributedStringElement {
  // own attributes
  var origin: Concept
  var target: Concept
  var originPoint: NSPoint { return origin.point }
  var targetPoint: NSPoint { return target.point }
  
  var point: NSPoint {
    return NSMakePoint(
      ((originPoint.x + targetPoint.x) / 2.0),
      ((originPoint.y + targetPoint.y) / 2.0)
    )
  }
  dynamic var color: NSColor
  
  // MARK: -NSAttributedStringElement
  dynamic var attributedStringValue: NSAttributedString
  var stringValue: String { return attributedStringValue.string }
  
  // MARK: - VisualElement
  var isEditable: Bool = false
  var isSelected: Bool = false
  
  private let padding: CGFloat = 20
  
  static let defaultColor = NSColor.gray
  
  override var description: String {
    return "'\(origin.stringValue)' '\(target.stringValue)'"
  }
  
  // Element
  var identifier: String
  var rect: NSRect {
    var minX = min(originPoint.x, targetPoint.x)
    if (abs(originPoint.x - targetPoint.x) <= padding) { minX -= padding / 2 }
    var minY = min(originPoint.y, targetPoint.y)
    if (abs(originPoint.y - targetPoint.y) <= padding) { minY -= padding / 2 }
    let maxX = max(originPoint.x, targetPoint.x)
    let maxY = max(originPoint.y, targetPoint.y)
    let width = max(maxX - minX, padding)
    let height = max(maxY - minY, padding)
    return NSMakeRect(minX, minY, width, height)
  }
  
  convenience init(origin: Concept, target: Concept) {
    self.init(origin: origin, target: target, attributedStringValue: NSAttributedString(string: ""))
  }
  
  init(origin: Concept, target: Concept, attributedStringValue: NSAttributedString) {
    self.origin = origin
    self.target = target
    self.identifier = "\(UUID().uuidString)-link"
    self.color = Link.defaultColor
    self.attributedStringValue = attributedStringValue
  }
  
  static let colorPath = "color"
  
  let identifierKey = "identifierKey"
  let originKey = "OriginKey"
  let targetKey = "TargetKey"
  let colorKey = "colorKey"
  let attributedStringValueKey = "attributedStringValue"
  
  required init?(coder aDecoder: NSCoder) {
    identifier = aDecoder.decodeObject(forKey: identifierKey) as! String
    origin = aDecoder.decodeObject(forKey: originKey) as! Concept
    target = aDecoder.decodeObject(forKey: targetKey) as! Concept
    attributedStringValue = aDecoder.decodeObject(forKey: attributedStringValueKey) as! NSAttributedString
    
    if let color = aDecoder.decodeObject(forKey: colorKey) as? NSColor {
      self.color = color
    } else {
      self.color = Link.defaultColor
    }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(identifier, forKey: identifierKey)
    aCoder.encode(origin, forKey: originKey)
    aCoder.encode(target, forKey: targetKey)
    aCoder.encode(color, forKey: colorKey)
    aCoder.encode(attributedStringValue, forKey: attributedStringValueKey)
  }
}
