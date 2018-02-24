//
//  Concept.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Foundation
import CoreGraphics

public class Concept: NSObject, NSCoding, Element {
  public enum Mode {
    case textBased
    case modifiedWidth(width: CGFloat)
  }

  // NOTE: the point value is relative to the canvas coordinate system
  public var centerPoint: CGPoint
  public var mode: Mode = .textBased

  public var area: CGRect {
    return CGRect(center: centerPoint, size: size)
  }

  public var horizontalPadding: CGFloat = 6
  public var verticalPadding: CGFloat = 3

  public var constrainedSize: CGSize? {
    switch mode {
    case .modifiedWidth(let width):
      return CGSize(width: width, height: 1e5)
    case .textBased:
      return nil
    }
  }

  private var size: CGSize {
    switch mode {
    case .textBased:
      return CGSize(width: textSize.width + horizontalPadding * 2, height: textSize.height + verticalPadding * 2)
    case .modifiedWidth(let width):
      return CGSize(width: width + horizontalPadding * 2, height: textSize.height + verticalPadding * 2)
    }
  }

  private var width: CGFloat {
    switch mode {
    case .textBased:
      return attributedStringValue.size().width
    case .modifiedWidth(let width):
      return width
    }
  }

  private var textSize: CGSize {
    let constrainSize = CGSize(width: width, height: 1e6)
    let value = attributedStringValue.boundingRect(
      with: constrainSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil
    ).size
    return value
  }

  private var textArea: CGRect {
    return CGRect(center: centerPoint, size: textSize)
  }

  // element
  public var identifier: String

  // MARK: - NSAttributedStringElement
  @objc dynamic public var attributedStringValue: NSAttributedString
  public var stringValue: String { return attributedStringValue.string }

  // visual element
  public var isEditable: Bool = false
  public var isSelected: Bool = false {
    didSet {
      self.leftHandler = isSelected ?  Handler(concept: self, position: .left) : nil
      self.rightHandler = isSelected ? Handler(concept: self, position: .right) : nil
    }
  }

  public var leftHandler: Handler?
  public var rightHandler: Handler?

  // KVO
  public static let attributedStringValuePath = "attributedStringValue"
  public static let centerPointPath = "point"
  public static let identifierPath = "identifier"
  public static let isEditablePath = "isEditable"

  // NSCoding
  static let attributedStringValueKey = "stringValueKey"
  static let centerPointKey = "pointKey"
  static let identifierKey = "identifierKey"
  static let isEditableKey = "isEditableKey"
  static let constrainedWidthKey = "constrainedWidthKey"

  // Moving
  public var beforeMovingPoint: CGPoint?

  override public var description: String {
    return "[\(identifier)] '\(stringValue)' \(isEditable) \(centerPoint)"
  }

  public override var debugDescription: String {
    return "[Concept][\(stringValue)]"
  }

  // MARK: - Initializers

  public convenience init(centerPoint: CGPoint) {
    self.init(stringValue: "", centerPoint: centerPoint)
  }

  public convenience init(stringValue: String, centerPoint: CGPoint) {
    self.init(attributedStringValue: NSAttributedString(string: stringValue), centerPoint: centerPoint)
  }

  public init(attributedStringValue: NSAttributedString, centerPoint: CGPoint) {
    self.centerPoint = centerPoint
    self.identifier = "\(UUID().uuidString)-concept"
    self.attributedStringValue = attributedStringValue
  }

  // MARK: - Methods

  public func draw() {
    if !isEditable {
      attributedStringValue.draw(in: textArea)
    }
  }

  public func contains(point: CGPoint) -> Bool {
    return area.contains(point)
  }

  public func updateWidth(withDifference: CGFloat, fromLeft: Bool = false) {
    let previousArea = area
    let previousWidth = width

    let newWidth = previousWidth + withDifference

    var previousSize = area.size
    previousSize.width += withDifference

    if fromLeft {
      centerPoint = CGRect(
        origin: CGPoint(x: previousArea.maxX - previousSize.width, y: previousArea.origin.y),
        size: previousSize
        ).center
    } else {
      centerPoint = CGRect(origin: previousArea.origin, size: previousSize).center
    }
    mode = .modifiedWidth(width: newWidth)
  }

  // MARK: - NSCoding

  required public init?(coder aDecoder: NSCoder) {
    guard let identifier = aDecoder.decodeObject(forKey: Concept.identifierKey) as? String,
          let attributedStringValue = aDecoder.decodeObject(
            forKey: Concept.attributedStringValueKey
          ) as? NSAttributedString
      else {
        return nil
    }
    self.identifier = identifier
    self.attributedStringValue = attributedStringValue
    centerPoint = aDecoder.decodeCGPoint(forKey: Concept.centerPointKey)
    isEditable = aDecoder.decodeBool(forKey: Concept.isEditableKey)

    if let widthObject = aDecoder.decodeObject(forKey: Concept.constrainedWidthKey) as? NSNumber {
      let constrainedWidth = CGFloat(widthObject.floatValue)
      self.mode = .modifiedWidth(width: constrainedWidth)
    } else {
      self.mode = .textBased
    }
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(centerPoint, forKey: Concept.centerPointKey)
    aCoder.encode(attributedStringValue, forKey: Concept.attributedStringValueKey)
    aCoder.encode(identifier, forKey: Concept.identifierKey)
    aCoder.encode(isEditable, forKey: Concept.isEditableKey)
    switch mode {
    case .modifiedWidth(let width):
      let widthValue = NSNumber(value: Float(width))
      aCoder.encode(widthValue, forKey: Concept.constrainedWidthKey)
    case .textBased:
      break
    }
  }
}
