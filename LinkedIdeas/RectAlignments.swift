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
    guard rects.count > 0 else {
      return rects
    }

    guard let minX = rects.map({ $0.origin.x }).min() else {
      assertionFailure("there should have been a minimun value for X within the rectangles")
      return rects
    }

    // the order of the rectangles must be preserved
    return rects.map({ (rect) -> NSRect in
      return NSRect(x: minX, y: rect.origin.y, width: rect.width, height: rect.height)
    })
  }

  static func verticallyCenterAlign(rects: [NSRect]) -> [NSRect] {
    guard rects.count > 0 else {
      return rects
    }

    guard let centerX = rects.first?.center.x else {
      assertionFailure("there should have been a center value for X within the rectangles")
      return rects
    }

    // the order of the rectangles must be preserved
    return rects.map({ (rect) -> NSRect in
      return NSRect(center: NSPoint(x: centerX, y: rect.center.y), size: rect.size)
    })
  }

  static func verticallyRightAlign(rects: [NSRect]) -> [NSRect] {
    guard rects.count > 0 else {
      return rects
    }

    guard let maxX = rects.map({ $0.origin.x + $0.width }).max() else {
      assertionFailure("there should have been a maximun value for X within the rectangles")
      return rects
    }

    // the order of the rectangles must be preserved
    return rects.map({ (rect) -> NSRect in
      let newX = maxX - rect.width
      return NSRect(x: newX, y: rect.origin.y, width: rect.width, height: rect.height)
    })
  }

  static func horizontallyCenterAlign(rects: [NSRect]) -> [NSRect] {
    guard !rects.isEmpty else {
      return rects
    }

    guard let averageYCoordinate = rects.map({ $0.center }).min(by: { $0.x < $1.x })?.y else {
      assertionFailure("I should have been able to calculate the average Y coordinate!")
      return rects
    }

    return rects.map({ (rect) -> NSRect in
      let newCenter = NSPoint(x: rect.center.x, y: averageYCoordinate)
      return NSRect(center: newCenter, size: rect.size)
    })
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
