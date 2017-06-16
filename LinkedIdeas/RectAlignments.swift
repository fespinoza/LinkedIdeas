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
    guard !rects.isEmpty else {
      return rects
    }

    let containingRect = self.containingRect(forRects: rects)

    let rectCount = CGFloat(rects.count)
    let combinedHeight = rects.reduce(0, { (acc, rect) in return acc + rect.height })
    let equalVerticalSpacing: CGFloat = (containingRect.height - combinedHeight) / (rectCount - 1)

    var orderedRects = [OrderedRect]()
    for (index, rect) in rects.enumerated() {
      orderedRects.append(OrderedRect(index: index, rect: rect))
    }

    let rectsSortedByYCoordinate: [OrderedRect] = orderedRects.sorted { $0.rect.center.y < $1.rect.center.y }

    var previousOrderedRect = rectsSortedByYCoordinate[0]

    func calculateNewOrigin(forRect rect: NSRect, withPreviousRect previousRect: NSRect) -> NSPoint {
      let newY = equalVerticalSpacing + previousRect.height + previousRect.origin.y
      return NSPoint(x: rect.origin.x, y: newY)
    }

    var modifiedOrderedRects = [previousOrderedRect]

    rectsSortedByYCoordinate[1..<rectsSortedByYCoordinate.count].forEach { (orderedRect) in
      let newRect = NSRect(
        origin: calculateNewOrigin(forRect: orderedRect.rect, withPreviousRect: previousOrderedRect.rect),
        size: orderedRect.rect.size
      )
      let newOrderedRect = OrderedRect(index: orderedRect.index, rect: newRect)
      modifiedOrderedRects.append(newOrderedRect)
      previousOrderedRect = newOrderedRect
    }

    return modifiedOrderedRects.sorted(by: { $0.index < $1.index }).map({ $0.rect })
  }

  static func equalHorizontalSpace(rects: [NSRect]) -> [NSRect] {
    guard !rects.isEmpty else {
      return rects
    }

    let containingRect = self.containingRect(forRects: rects)

    let rectCount = CGFloat(rects.count)
    let combinedWidth = rects.reduce(0, { (acc, rect) in return acc + rect.width })
    let equalHorizontalSpacing: CGFloat = (containingRect.width - combinedWidth) / (rectCount - 1)

    var orderedRects = [OrderedRect]()
    for (index, rect) in rects.enumerated() {
      orderedRects.append(OrderedRect(index: index, rect: rect))
    }

    let rectsSortedByXCoordinate: [OrderedRect] = orderedRects.sorted { $0.rect.center.x < $1.rect.center.x }

    var previousOrderedRect = rectsSortedByXCoordinate[0]

    func calculateNewOrigin(forRect rect: NSRect, withPreviousRect previousRect: NSRect) -> NSPoint {
      let newX = equalHorizontalSpacing + previousRect.width + previousRect.origin.x
      return NSPoint(x: newX, y: rect.origin.y)
    }

    var modifiedOrderedRects = [previousOrderedRect]

    rectsSortedByXCoordinate[1..<rectsSortedByXCoordinate.count].forEach { (orderedRect) in
      let newRect = NSRect(
        origin: calculateNewOrigin(forRect: orderedRect.rect, withPreviousRect: previousOrderedRect.rect),
        size: orderedRect.rect.size
      )
      let newOrderedRect = OrderedRect(index: orderedRect.index, rect: newRect)
      modifiedOrderedRects.append(newOrderedRect)
      previousOrderedRect = newOrderedRect
    }

    return modifiedOrderedRects.sorted(by: { $0.index < $1.index }).map({ $0.rect })
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
}
