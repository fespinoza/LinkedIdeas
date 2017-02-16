//
//  AligmentFunctions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/05/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol AlignmentFunctions {
  func setNewPoint(_ newPoint: NSPoint, forElement element: SquareElement)
}

extension AlignmentFunctions {
  func rectMaxX(rect: NSRect) -> CGFloat {
    return rect.origin.x + rect.width
  }

  func rectMaxY(rect: NSRect) -> CGFloat {
    return rect.origin.y + rect.height
  }

  func rectMinX(rect: NSRect) -> CGFloat {
    return rect.origin.x
  }

  func rectMinY(rect: NSRect) -> CGFloat {
    return rect.origin.y
  }

  // MARK: - SquareElement
  func compareByMaxRectX(_ point1: SquareElement, point2: SquareElement) -> Bool {
    return rectMaxX(rect: point1.rect) > rectMaxX(rect: point2.rect)
  }

  func compareByMinRectX(_ point1: SquareElement, point2: SquareElement) -> Bool {
    return rectMinX(rect: point1.rect) < rectMinX(rect: point2.rect)
  }

  func compareByMinCenterX(_ point1: SquareElement, point2: SquareElement) -> Bool {
    return point1.point.x < point2.point.x
  }

  func compareByMinCenterY(_ point1: SquareElement, point2: SquareElement) -> Bool {
    return point1.point.y < point2.point.y
  }

  // MARK: - Alignment Functions
  func verticallyCenterAlign(_ elements: [SquareElement]) {
    guard !elements.isEmpty else {
      return
    }

    let sortedConcepts = elements.sorted(by: compareByMinCenterX)
    let minimunXCoordinate = sortedConcepts.first!.point.x

    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      return NSPoint(x: minimunXCoordinate, y: element.point.y)
    }

    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }

  func verticallyLeftAlign(_ elements: [SquareElement]) {
    guard !elements.isEmpty else {
      return
    }

    let sortedConcepts = elements.sorted(by: compareByMinRectX)
    let minimunXCoordinate = sortedConcepts.first!.rect.origin.x

    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      let newX: CGFloat = minimunXCoordinate + element.rect.width / 2
      return NSPoint(x: newX, y: element.point.y)
    }

    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }

  func verticallyRightAlign(_ elements: [SquareElement]) {
    guard !elements.isEmpty else {
      return
    }

    let sortedConcepts = elements.sorted(by: compareByMaxRectX)
    let minimunXCoordinate = rectMaxX(rect: sortedConcepts.first!.rect)

    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      let newX: CGFloat = minimunXCoordinate - element.rect.width / 2
      return NSPoint(x: newX, y: element.point.y)
    }

    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }

  func horizontallyAlign(_ elements: [SquareElement]) {
    guard !elements.isEmpty else {
      return
    }

    let averageYCoordinate: CGFloat = elements.min(by: compareByMinCenterX)!.point.y

    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      return NSPoint(x: element.point.x, y: averageYCoordinate)
    }

    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }

  func equalVerticalSpace(_ elements: [SquareElement]) {
    guard !elements.isEmpty else {
      return
    }

    let containingRect = containingRectFor(elements)

    let n = CGFloat(elements.count)
    let combinedConceptHeight = elements.reduce(0, { (acc, concept) in return acc + concept.rect.height })
    let equalVerticalSpacing: CGFloat = (containingRect.height - combinedConceptHeight) / (n - 1)

    let elementsSortedByYCoordinate = elements.sorted(by: compareByMinCenterY)

    var previousElement = elementsSortedByYCoordinate[0]

    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      let newY = (element.rect.height / 2) + equalVerticalSpacing +
                 (previousElement.rect.height / 2) + previousElement.point.y
      return NSPoint(x: element.point.x, y: newY)
    }

    for element in elementsSortedByYCoordinate[1..<elementsSortedByYCoordinate.count] {
      setNewPoint(calculateNewPoint(element), forElement: element)
      previousElement = element
    }
  }

  func equalHorizontalSpace(_ elements: [SquareElement]) {
    guard !elements.isEmpty else {
      return
    }

    let containingRect = containingRectFor(elements)

    let n = CGFloat(elements.count)
    let combinedConceptWidth = elements.reduce(0, { (acc, concept) in return acc + concept.rect.width })
    let equalHorizontalSpacing: CGFloat = (containingRect.width - combinedConceptWidth) / (n - 1)

    let conceptsSortedByXCoordinate = elements.sorted(by: compareByMinCenterX)

    var previousConcept = conceptsSortedByXCoordinate[0]
    for element in conceptsSortedByXCoordinate[1..<conceptsSortedByXCoordinate.count] {
      let newX = (element.rect.width / 2) + equalHorizontalSpacing +
                 (previousConcept.rect.width / 2) + previousConcept.point.x
      let newPoint = NSPoint(x: newX, y: element.point.y)

      setNewPoint(newPoint, forElement: element)

      previousConcept = element
    }
  }

  // MARK: - Utilities
  func setNewPoint(_ newPoint: NSPoint, forElement element: SquareElement) {
    element.point = newPoint
  }

  func updateElementPoints(_ elements: [SquareElement], newPointCalculator: (SquareElement) -> NSPoint) {
    for element in elements {
      setNewPoint(newPointCalculator(element), forElement: element)
    }
  }

  func containingRectFor(_ elements: [SquareElement]) -> NSRect {
    let minX = (elements.map { rectMinX(rect: $0.rect) }).min()!
    let minY = (elements.map { rectMinY(rect: $0.rect) }).min()!
    let maxX = (elements.map { rectMaxX(rect: $0.rect) }).max()!
    let maxY = (elements.map { rectMaxY(rect: $0.rect) }).max()!
    return NSRect(
      origin: NSPoint(x: minX, y: minY),
      size: NSSize(width: maxX - minX, height: maxY - minY)
    )
  }
}
