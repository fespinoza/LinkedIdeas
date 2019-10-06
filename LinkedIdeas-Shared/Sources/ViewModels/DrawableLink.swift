//
//  DrawableLink.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import CoreGraphics
import Foundation

extension Color {
  /// converts a given color to the same color space and does some simplified math in order to see
  /// if the colors are close enought to be considered the same
  func isClose(to otherColor: Color) -> Bool {
    guard let otherColor = otherColor.usingColorSpace(self.colorSpace) else {
      return false
    }

    return floor(self.redComponent * 255) == floor(otherColor.redComponent * 255) &&
      floor(self.greenComponent * 255) == floor(otherColor.greenComponent * 255) &&
      floor(self.blueComponent * 255) == floor(otherColor.blueComponent * 255) &&
      floor(self.alphaComponent * 255) == floor(otherColor.alphaComponent * 255)
  }
}

public struct DrawableLink: DrawableElement {
  let link: Link

  public init(link: Link) {
    self.link = link
  }

  public var drawingBounds: CGRect {
    return CGRect(point1: link.originPoint, point2: link.targetPoint)
  }

  public func draw() {
    if link.color.isClose(to: DefaultColors.lightModeLinkColor) {
      DefaultColors.linkColor.set()
    } else {
      link.color.set()
    }
    constructArrow()?.bezierPath().fill()
    drawSelectedRing()
    drawLinkText()
    drawForDebug()
  }

  func drawLinkText() {
    guard link.stringValue != "" else {
      return
    }

    // background
    Color.windowBackgroundColor.set()
    var textSize = link.attributedStringValue.size()
    let padding: CGFloat = 8.0
    textSize.width += padding
    textSize.height += padding

    let textRect = CGRect(center: link.centerPoint, size: textSize)
    textRect.fill()

    // text
    let bottomLeftTextPoint = link.centerPoint.translate(
      deltaX: -(textSize.width - padding) / 2.0,
      deltaY: -(textSize.height - padding) / 2.0
    )
    // swiftlint:disable:next force_cast
    let attributedStringValue = link.attributedStringValue.mutableCopy() as! NSMutableAttributedString
    attributedStringValue.addAttributes(
      [.foregroundColor: Color.gray],
      range: NSRangeFromString(link.attributedStringValue.string)
    )
    attributedStringValue.draw(at: bottomLeftTextPoint)
  }

  func drawSelectedRing() {
    guard link.isSelected else {
      return
    }

    DefaultColors.selectionLink.set()
    constructArrow()?.bezierPath().stroke()
  }

  func constructArrow() -> Arrow? {
    let originPoint = link.originPoint
    let targetPoint = link.targetPoint

    if let intersectionPointWithOrigin = link.originRect.firstIntersectionTo(targetPoint),
      let intersectionPointWithTarget = link.targetRect.firstIntersectionTo(originPoint) {
      return Arrow(point1: intersectionPointWithOrigin, point2: intersectionPointWithTarget)
    } else {
      return nil
    }
  }

  public func drawForDebug() {
    if isDebugging() {
      drawDebugHelpers()
      Color.magenta.set()
      BezierPath(rect: link.area).stroke()
    }
  }
}
