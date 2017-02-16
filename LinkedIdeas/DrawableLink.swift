//
//  DrawableLink.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct DrawableLink: DrawableElement {
  let link: GraphLink

  func draw() {
    link.color.set()
    constructArrow()?.bezierPath().fill()
    drawSelectedRing()
    drawLinkText()
  }

  func drawLinkText() {
    guard link.stringValue != "" else {
      return
    }

    // background
    NSColor.white.set()
    var textSize = link.attributedStringValue.size()
    let padding: CGFloat = 8.0
    textSize.width += padding
    textSize.height += padding

    let textRect = NSRect(center: link.point, size: textSize)
    NSRectFill(textRect)

    // text
    let bottomLeftTextPoint = link.point.translate(
      deltaX: -(textSize.width - padding) / 2.0,
      deltaY: -(textSize.height - padding) / 2.0
    )
    let attributedStringValue = NSAttributedString(
      attributedString: link.attributedStringValue,
      fontColor: NSColor.gray
    )
    attributedStringValue.draw(at: bottomLeftTextPoint)
  }

  func drawSelectedRing() {
    guard link.isSelected else {
      return
    }

    NSColor.red.set()
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
}
