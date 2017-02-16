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
    return NSPoint(
      x: ((originPoint.x + targetPoint.x) / 2.0),
      y: ((originPoint.y + targetPoint.y) / 2.0)
    )
  }

  let textRectPadding: CGFloat = 8.0
  var textRect: NSRect {
    var textSizeWithPadding = attributedStringValue.size()
    textSizeWithPadding.width += textRectPadding
    textSizeWithPadding.height += textRectPadding
    return NSRect(center: point, size: textSizeWithPadding)
  }

  dynamic var color: NSColor

  // MARK: - NSAttributedStringElement
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
    if abs(originPoint.x - targetPoint.x) <= padding { minX -= padding / 2 }
    var minY = min(originPoint.y, targetPoint.y)
    if abs(originPoint.y - targetPoint.y) <= padding { minY -= padding / 2 }
    let maxX = max(originPoint.x, targetPoint.x)
    let maxY = max(originPoint.y, targetPoint.y)
    let width = max(maxX - minX, padding)
    let height = max(maxY - minY, padding)
    return NSRect(x: minX, y: minY, width: width, height: height)
  }

  func contains(point: NSPoint) -> Bool {
    guard rect.contains(point) else {
      return false
    }
    if textRect.contains(point) {
      return true
    }

    let extendedAreaArrow = Arrow(point1: originPoint, point2: targetPoint, arrowBodyWidth: 20)
    let minXPoint: NSPoint! = extendedAreaArrow.arrowBodyPoints()
      .min { (pointA, pointB) -> Bool in pointA.x < pointB.x }
    let maxXPoint: NSPoint! = extendedAreaArrow.arrowBodyPoints()
      .max { (pointA, pointB) -> Bool in pointA.x < pointB.x }

    let linkLine = Line(pointA: originPoint, pointB: targetPoint)
    let pivotPoint = NSPoint(x: linkLine.evaluateY(0), y: 0)

    let angledLine = Line(pointA: pivotPoint, pointB: minXPoint)
    let a = angledLine.intersectionWithYAxis
    let b = angledLine.intersectionWithXAxis
    let c: CGFloat = sqrt(pow(a, 2) + pow(b, 2))
    let sin_theta = a / c
    let cos_theta = b / c

    func transformationFunction(ofPoint pointToTransform: NSPoint) -> NSPoint {
      return NSPoint(
        x: pointToTransform.x * cos_theta - sin_theta * pointToTransform.y - minXPoint.x,
        y: pointToTransform.x * sin_theta + cos_theta * pointToTransform.y - minXPoint.y
      )
    }

    let transformedRect = NSRect(
      point1: transformationFunction(ofPoint: minXPoint),
      point2: transformationFunction(ofPoint: maxXPoint)
    )
    let transformedPoint = transformationFunction(ofPoint: point)
    return transformedRect.contains(transformedPoint)
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

  // MARK: - KVO
  static let colorPath = "color"
  static let attributedStringValuePath = "attributedStringValue"

  let identifierKey = "identifierKey"
  let originKey = "OriginKey"
  let targetKey = "TargetKey"
  let colorKey = "colorKey"
  let attributedStringValueKey = "attributedStringValue"

  required init?(coder aDecoder: NSCoder) {
    guard let identifier = aDecoder.decodeObject(forKey: identifierKey) as? String,
      let origin = aDecoder.decodeObject(forKey: originKey) as? Concept,
      let target = aDecoder.decodeObject(forKey: targetKey) as? Concept,
      let attributedStringValue = aDecoder.decodeObject(
        forKey: attributedStringValueKey
        ) as? NSAttributedString
      else {
        return nil
    }

    self.identifier = identifier
    self.origin = origin
    self.target = target
    self.attributedStringValue = attributedStringValue

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
