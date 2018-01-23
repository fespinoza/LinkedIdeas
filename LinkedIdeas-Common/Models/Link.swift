//
//  <.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//
#if os(iOS)
  import UIKit
  public typealias Color = UIColor
#else
  import AppKit
  public typealias Color = NSColor
#endif

public class Link: NSObject, NSCoding {
  // own attributes
  var origin: Concept
  var target: Concept
  public var originPoint: CGPoint { return origin.centerPoint }
  public var targetPoint: CGPoint { return target.centerPoint }

  public var centerPoint: CGPoint {
    return CGPoint(
      x: ((originPoint.x + targetPoint.x) / 2.0),
      y: ((originPoint.y + targetPoint.y) / 2.0)
    )
  }

  let textRectPadding: CGFloat = 8.0
  var textRect: CGRect {
    var textSizeWithPadding = attributedStringValue.size()
    textSizeWithPadding.width += textRectPadding
    textSizeWithPadding.height += textRectPadding
    return CGRect(center: centerPoint, size: textSizeWithPadding)
  }

  @objc dynamic public var color: Color

  // MARK: - NSAttributedStringElement
  @objc dynamic public var attributedStringValue: NSAttributedString
  public var stringValue: String { return attributedStringValue.string }

  // MARK: - VisualElement
  var isEditable: Bool = false
  public var isSelected: Bool = false

  private let padding: CGFloat = 20

  static let defaultColor = Color.gray

  override public var description: String {
    return "'\(origin.stringValue)' '\(target.stringValue)'"
  }

  // Element
  var identifier: String
  public var area: CGRect {
    var minX = min(originPoint.x, targetPoint.x)
    if abs(originPoint.x - targetPoint.x) <= padding { minX -= padding / 2 }
    var minY = min(originPoint.y, targetPoint.y)
    if abs(originPoint.y - targetPoint.y) <= padding { minY -= padding / 2 }
    let maxX = max(originPoint.x, targetPoint.x)
    let maxY = max(originPoint.y, targetPoint.y)
    let width = max(maxX - minX, padding)
    let height = max(maxY - minY, padding)
    return CGRect(x: minX, y: minY, width: width, height: height)
  }

//  func contains(point: CGPoint) -> Bool {
//    guard area.contains(point) else {
//      return false
//    }
//    if textRect.contains(point) {
//      return true
//    }
//
////    let extendedAreaArrow = Arrow(point1: originPoint, point2: targetPoint, arrowBodyWidth: 20)
////    let minXPoint: CGPoint! = extendedAreaArrow.arrowBodyPoints()
////      .min { (pointA, pointB) -> Bool in pointA.x < pointB.x }
////    let maxXPoint: CGPoint! = extendedAreaArrow.arrowBodyPoints()
////      .max { (pointA, pointB) -> Bool in pointA.x < pointB.x }
////
////    let linkLine = Line(pointA: originPoint, pointB: targetPoint)
////    let pivotPoint = CGPoint(x: linkLine.evaluateY(0), y: 0)
////
////    let angledLine = Line(pointA: pivotPoint, pointB: minXPoint)
////    let a = angledLine.intersectionWithYAxis
////    let b = angledLine.intersectionWithXAxis
////    let c: CGFloat = sqrt(pow(a, 2) + pow(b, 2))
////    let sin_theta = a / c
////    let cos_theta = b / c
//
//    func transformationFunction(ofPoint pointToTransform: CGPoint) -> CGPoint {
//      return CGPoint(
//        x: pointToTransform.x * cos_theta - sin_theta * pointToTransform.y - minXPoint.x,
//        y: pointToTransform.x * sin_theta + cos_theta * pointToTransform.y - minXPoint.y
//      )
//    }
//
//    let transformedRect = CGRect(
//      point1: transformationFunction(ofPoint: minXPoint),
//      point2: transformationFunction(ofPoint: maxXPoint)
//    )
//    let transformedPoint = transformationFunction(ofPoint: point)
//    return transformedRect.contains(transformedPoint)
//  }

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
  let colorComponentsKey = "colorComponentsKey"

  func doesBelongTo(concept: Concept) -> Bool {
    return origin == concept || target == concept
  }

  required public init?(coder aDecoder: NSCoder) {
    guard let identifier = aDecoder.decodeObject(forKey: identifierKey) as? String,
      let origin = aDecoder.decodeObject(forKey: originKey) as? Concept,
      let target = aDecoder.decodeObject(forKey: targetKey) as? Concept else {
        return nil
    }

    self.identifier = identifier
    self.origin = origin
    self.target = target

    if let attributedStringValue = aDecoder.decodeObject(forKey: attributedStringValueKey) as? NSAttributedString {
      self.attributedStringValue = attributedStringValue
    } else {
      self.attributedStringValue = NSAttributedString(string: "")
    }

//    if let colorComponents = aDecoder.decodeObject(forKey: colorComponentsKey) as? [CGFloat] {
//      self.color = ColorUtils.color(fromComponents: colorComponents)
//    } else {
      if let color = aDecoder.decodeObject(forKey: colorKey) as? Color {
        self.color = color
      } else {
        self.color = Link.defaultColor
      }
//    }
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(identifier, forKey: identifierKey)
    aCoder.encode(origin, forKey: originKey)
    aCoder.encode(target, forKey: targetKey)
    aCoder.encode(Link.defaultColor, forKey: colorComponentsKey)
//    aCoder.encode(ColorUtils.extractColorComponents(forColor: color), forKey: colorComponentsKey)
    aCoder.encode(attributedStringValue, forKey: attributedStringValueKey)
  }
}
