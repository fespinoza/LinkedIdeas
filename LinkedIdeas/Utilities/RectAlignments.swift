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
    let rect: CGRect
  }

  static func verticallyLeftAlign(rects: [CGRect]) -> [CGRect] {
    func calculateMinX(rects: [CGRect]) -> CGFloat? {
      return rects.map({ $0.origin.x }).min()
    }

    func leftAlign(rect: CGRect, forMinX minX: CGFloat) -> CGRect {
      return CGRect(x: minX, y: rect.origin.y, width: rect.width, height: rect.height)
    }

    return applyAlignment(toRects: rects, calculateAligmentParam: calculateMinX, alignRect: leftAlign)
  }

  static func verticallyCenterAlign(rects: [CGRect]) -> [CGRect] {
    func calculateCenterX(rects: [CGRect]) -> CGFloat? {
      return rects.first?.center.x
    }

    func centerAlign(rect: CGRect, forCenterX centerX: CGFloat) -> CGRect {
      return CGRect(center: CGPoint(x: centerX, y: rect.center.y), size: rect.size)
    }

    return applyAlignment(toRects: rects, calculateAligmentParam: calculateCenterX, alignRect: centerAlign)
  }

  static func verticallyRightAlign(rects: [CGRect]) -> [CGRect] {
    func calculateMaxX(rects: [CGRect]) -> CGFloat? {
      return rects.map({ $0.origin.x + $0.width }).max()
    }

    func rightAlign(rect: CGRect, forMaxX maxX: CGFloat) -> CGRect {
      let newX = maxX - rect.width
      return CGRect(x: newX, y: rect.origin.y, width: rect.width, height: rect.height)
    }

    return applyAlignment(toRects: rects, calculateAligmentParam: calculateMaxX, alignRect: rightAlign)
  }

  static func horizontallyCenterAlign(rects: [CGRect]) -> [CGRect] {
    func calculateAverageYCoordinate(rects: [CGRect]) -> CGFloat? {
      return rects.map({ $0.center }).min(by: { $0.x < $1.x })?.y
    }

    func centerAlign(rect: CGRect, forAverageYCoordinate averageYCoordinate: CGFloat) -> CGRect {
      let newCenter = CGPoint(x: rect.center.x, y: averageYCoordinate)
      return CGRect(center: newCenter, size: rect.size)
    }

    return applyAlignment(toRects: rects, calculateAligmentParam: calculateAverageYCoordinate, alignRect: centerAlign)
  }

  static func equalVerticalSpace(rects: [CGRect]) -> [CGRect] {
    func byCenterY(_ rectA: OrderedRect, _ rectB: OrderedRect) -> Bool {
      return rectA.rect.center.y < rectB.rect.center.y
    }

    func calculateVerticalSpacing(_ rects: [CGRect]) -> CGFloat {
      let containingRect = self.containingRect(forRects: rects)
      let rectCount = CGFloat(rects.count)
      let combinedHeight = rects.reduce(0, { (acc, rect) in return acc + rect.height })
      return (containingRect.height - combinedHeight) / (rectCount - 1)
    }

    func calculateNewOrigin(
      forRect rect: CGRect,
      withPreviousRect previousRect: CGRect,
      andVerticalSpacing equalVerticalSpacing: CGFloat
    ) -> CGPoint {
      let newY = equalVerticalSpacing + previousRect.height + previousRect.origin.y
      return CGPoint(x: rect.origin.x, y: newY)
    }

    return distribute(
      rects: rects,
      orderComparison: byCenterY,
      calculateSpacing: calculateVerticalSpacing,
      calculateNewOrigin: calculateNewOrigin
    )
  }

  static func equalHorizontalSpace(rects: [CGRect]) -> [CGRect] {
    func byCenterX(_ rectA: OrderedRect, _ rectB: OrderedRect) -> Bool {
      return rectA.rect.center.x < rectB.rect.center.x
    }

    func calculateVerticalSpacing(_ rects: [CGRect]) -> CGFloat {
      let containingRect = self.containingRect(forRects: rects)
      let rectCount = CGFloat(rects.count)
      let combinedWidth = rects.reduce(0, { (acc, rect) in return acc + rect.width })
      return (containingRect.width - combinedWidth) / (rectCount - 1)
    }

    func calculateNewOrigin(
      forRect rect: CGRect,
      withPreviousRect previousRect: CGRect,
      andEqualHorizontalSpacing equalHorizontalSpacing: CGFloat
    ) -> CGPoint {
      let newX = equalHorizontalSpacing + previousRect.width + previousRect.origin.x
      return CGPoint(x: newX, y: rect.origin.y)
    }

    return distribute(
      rects: rects,
      orderComparison: byCenterX,
      calculateSpacing: calculateVerticalSpacing,
      calculateNewOrigin: calculateNewOrigin
    )
  }

  static func containingRect(forRects rects: [CGRect]) -> CGRect {
    let minX = (rects.map { $0.origin.x }).min()!
    let minY = (rects.map { $0.origin.y }).min()!
    let maxX = (rects.map { $0.maxX }).max()!
    let maxY = (rects.map { $0.maxY }).max()!
    return CGRect(
      origin: CGPoint(x: minX, y: minY),
      size: CGSize(width: maxX - minX, height: maxY - minY)
    )
  }

  // MARK: - private functions

  private static func applyAlignment(
    toRects rects: [CGRect],
    calculateAligmentParam: ([CGRect]) -> CGFloat?,
    alignRect: (CGRect, CGFloat) -> CGRect
  ) -> [CGRect] {
    guard rects.count > 0 else {
      return rects
    }

    guard let aligmentParam = calculateAligmentParam(rects) else {
      assertionFailure("there should have been an aligment parameter for the set of rectangles")
      return rects
    }

    // the order of the rectangles must be preserved
    return rects.map({ (rect) -> CGRect in
      return alignRect(rect, aligmentParam)
    })
  }

  private static func distribute(
    rects: [CGRect],
    orderComparison: (OrderedRect, OrderedRect) -> Bool,
    calculateSpacing: ([CGRect]) -> CGFloat,
    calculateNewOrigin: (CGRect, CGRect, CGFloat) -> CGPoint
  ) -> [CGRect] {
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
      let newRect = CGRect(
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
