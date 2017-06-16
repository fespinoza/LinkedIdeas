//
//  RectAlignments.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 09/06/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

struct RectAlignments {
  private struct OrderedRect {
    let index: Int
    let rect: NSRect
  }

  static func verticallyLeftAlign(rects: [NSRect]) -> [NSRect] {
    func calculateMinX(rects: [NSRect]) -> CGFloat? {
      return rects.map({ $0.origin.x }).min()
    }

    func leftAlign(rect: NSRect, forMinX minX: CGFloat) -> NSRect {
      return NSRect(x: minX, y: rect.origin.y, width: rect.width, height: rect.height)
    }

    return applyAlignment(toRects: rects, calculateAligmentParam: calculateMinX, alignRect: leftAlign)
  }

  static func verticallyCenterAlign(rects: [NSRect]) -> [NSRect] {
    func calculateCenterX(rects: [NSRect]) -> CGFloat? {
      return rects.first?.center.x
    }

    func centerAlign(rect: NSRect, forCenterX centerX: CGFloat) -> NSRect {
      return NSRect(center: NSPoint(x: centerX, y: rect.center.y), size: rect.size)
    }

    return applyAlignment(toRects: rects, calculateAligmentParam: calculateCenterX, alignRect: centerAlign)
  }

  static func verticallyRightAlign(rects: [NSRect]) -> [NSRect] {
    func calculateMaxX(rects: [NSRect]) -> CGFloat? {
      return rects.map({ $0.origin.x + $0.width }).max()
    }

    func rightAlign(rect: NSRect, forMaxX maxX: CGFloat) -> NSRect {
      let newX = maxX - rect.width
      return NSRect(x: newX, y: rect.origin.y, width: rect.width, height: rect.height)
    }

    return applyAlignment(toRects: rects, calculateAligmentParam: calculateMaxX, alignRect: rightAlign)
  }

  static func horizontallyCenterAlign(rects: [NSRect]) -> [NSRect] {
    func calculateAverageYCoordinate(rects: [NSRect]) -> CGFloat? {
      return rects.map({ $0.center }).min(by: { $0.x < $1.x })?.y
    }

    func centerAlign(rect: NSRect, forAverageYCoordinate averageYCoordinate: CGFloat) -> NSRect {
      let newCenter = NSPoint(x: rect.center.x, y: averageYCoordinate)
      return NSRect(center: newCenter, size: rect.size)
    }

    return applyAlignment(toRects: rects, calculateAligmentParam: calculateAverageYCoordinate, alignRect: centerAlign)
  }

  static func equalVerticalSpace(rects: [NSRect]) -> [NSRect] {
    func byCenterY(_ rectA: OrderedRect, _ rectB: OrderedRect) -> Bool {
      return rectA.rect.center.y < rectB.rect.center.y
    }

    func calculateVerticalSpacing(_ rects: [NSRect]) -> CGFloat {
      let containingRect = self.containingRect(forRects: rects)
      let rectCount = CGFloat(rects.count)
      let combinedHeight = rects.reduce(0, { (acc, rect) in return acc + rect.height })
      return (containingRect.height - combinedHeight) / (rectCount - 1)
    }

    func calculateNewOrigin(
      forRect rect: NSRect,
      withPreviousRect previousRect: NSRect,
      andVerticalSpacing equalVerticalSpacing: CGFloat
    ) -> NSPoint {
      let newY = equalVerticalSpacing + previousRect.height + previousRect.origin.y
      return NSPoint(x: rect.origin.x, y: newY)
    }

    return distribute(
      rects: rects,
      orderComparison: byCenterY,
      calculateSpacing: calculateVerticalSpacing,
      calculateNewOrigin: calculateNewOrigin
    )
  }

  static func equalHorizontalSpace(rects: [NSRect]) -> [NSRect] {
    func byCenterX(_ rectA: OrderedRect, _ rectB: OrderedRect) -> Bool {
      return rectA.rect.center.x < rectB.rect.center.x
    }

    func calculateVerticalSpacing(_ rects: [NSRect]) -> CGFloat {
      let containingRect = self.containingRect(forRects: rects)
      let rectCount = CGFloat(rects.count)
      let combinedWidth = rects.reduce(0, { (acc, rect) in return acc + rect.width })
      return (containingRect.width - combinedWidth) / (rectCount - 1)
    }

    func calculateNewOrigin(
      forRect rect: NSRect,
      withPreviousRect previousRect: NSRect,
      andEqualHorizontalSpacing equalHorizontalSpacing: CGFloat
    ) -> NSPoint {
      let newX = equalHorizontalSpacing + previousRect.width + previousRect.origin.x
      return NSPoint(x: newX, y: rect.origin.y)
    }

    return distribute(
      rects: rects,
      orderComparison: byCenterX,
      calculateSpacing: calculateVerticalSpacing,
      calculateNewOrigin: calculateNewOrigin
    )
  }

  static func containingRect(forRects rects: [NSRect]) -> NSRect {
    let minX = (rects.map { $0.origin.x }).min()!
    let minY = (rects.map { $0.origin.y }).min()!
    let maxX = (rects.map { $0.maxX }).max()!
    let maxY = (rects.map { $0.maxY }).max()!
    return NSRect(
      origin: NSPoint(x: minX, y: minY),
      size: NSSize(width: maxX - minX, height: maxY - minY)
    )
  }

  // MARK: - private functions

  private static func applyAlignment(
    toRects rects: [NSRect],
    calculateAligmentParam: ([NSRect]) -> CGFloat?,
    alignRect: (NSRect, CGFloat) -> NSRect
  ) -> [NSRect] {
    guard rects.count > 0 else {
      return rects
    }

    guard let aligmentParam = calculateAligmentParam(rects) else {
      assertionFailure("there should have been an aligment parameter for the set of rectangles")
      return rects
    }

    // the order of the rectangles must be preserved
    return rects.map({ (rect) -> NSRect in
      return alignRect(rect, aligmentParam)
    })
  }

  private static func distribute(
    rects: [NSRect],
    orderComparison: (OrderedRect, OrderedRect) -> Bool,
    calculateSpacing: ([NSRect]) -> CGFloat,
    calculateNewOrigin: (NSRect, NSRect, CGFloat) -> NSPoint
  ) -> [NSRect] {
    guard !rects.isEmpty else {
      return rects
    }

    let spacingParam = calculateSpacing(rects)

    var orderedRects = [OrderedRect]()
    for (index, rect) in rects.enumerated() {
      orderedRects.append(OrderedRect(index: index, rect: rect))
    }

    let sortedRects: [OrderedRect] = orderedRects.sorted(by: orderComparison)

    var previousOrderedRect = sortedRects[0]

    var modifiedOrderedRects = [previousOrderedRect]

    sortedRects[1..<sortedRects.count].forEach { (orderedRect) in
      let newRect = NSRect(
        origin: calculateNewOrigin(orderedRect.rect, previousOrderedRect.rect, spacingParam),
        size: orderedRect.rect.size
      )
      let newOrderedRect = OrderedRect(index: orderedRect.index, rect: newRect)
      modifiedOrderedRects.append(newOrderedRect)
      previousOrderedRect = newOrderedRect
    }

    return modifiedOrderedRects.sorted(by: { $0.index < $1.index }).map({ $0.rect })
  }
}
