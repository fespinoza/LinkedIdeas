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
  // MARK: - SquareElement
  func compareByMaxRectX(_ p1: SquareElement, p2: SquareElement) -> Bool {
    return p1.rect.maxX > p2.rect.maxX
  }
  
  func compareByMinRectX(_ p1: SquareElement, p2: SquareElement) -> Bool {
    return p1.rect.origin.x < p2.rect.origin.x
  }
  
  func compareByMinCenterX(_ p1: SquareElement, p2: SquareElement) -> Bool {
    return p1.point.x < p2.point.x
  }
  
  func compareByMinCenterY(_ p1: SquareElement, p2: SquareElement) -> Bool {
    return p1.point.y < p2.point.y
  }
  
  // MARK: - Alignment Functions
  func verticallyCenterAlign(_ elements: [SquareElement]) {
    guard !elements.isEmpty else { return }
    
    let sortedConcepts = elements.sorted(by: compareByMinCenterX)
    let minimunXCoordinate = sortedConcepts.first!.point.x
    
    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      return NSMakePoint(minimunXCoordinate, element.point.y)
    }
    
    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }
  
  func verticallyLeftAlign(_ elements: [SquareElement]) {
    guard !elements.isEmpty else { return }
    
    let sortedConcepts = elements.sorted(by: compareByMinRectX)
    let minimunXCoordinate = sortedConcepts.first!.rect.origin.x
    
    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      let newX: CGFloat = minimunXCoordinate + element.rect.width / 2
      return NSMakePoint(newX, element.point.y)
    }
    
    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }
  
  func verticallyRightAlign(_ elements: [SquareElement]) {
    guard !elements.isEmpty else { return }
    
    let sortedConcepts = elements.sorted(by: compareByMaxRectX)
    let minimunXCoordinate = sortedConcepts.first!.rect.maxX
    
    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      let newX: CGFloat = minimunXCoordinate - element.rect.width / 2
      return NSMakePoint(newX, element.point.y)
    }
    
    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }
  
  func horizontallyAlign(_ elements: [SquareElement]) {
    guard !elements.isEmpty else { return }
    
    let averageYCoordinate: CGFloat = elements.min(by: compareByMinCenterX)!.point.y
    
    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      return NSMakePoint(element.point.x, averageYCoordinate)
    }
    
    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }
  
  func equalVerticalSpace(_ elements: [SquareElement]) {
    guard !elements.isEmpty else { return }
    
    let containingRect = containingRectFor(elements)
    
    let n = CGFloat(elements.count)
    let combinedConceptHeight = elements.reduce(0, { (acc, concept) in return acc + concept.rect.height })
    let equalVerticalSpacing: CGFloat = (containingRect.height - combinedConceptHeight) / (n - 1)
    
    let elementsSortedByYCoordinate = elements.sorted(by: compareByMinCenterY)
    
    var previousElement = elementsSortedByYCoordinate[0]
    
    func calculateNewPoint(_ element: SquareElement) -> NSPoint {
      let newY = (element.rect.height / 2) + equalVerticalSpacing + (previousElement.rect.height / 2) + previousElement.point.y
      return NSMakePoint(element.point.x, newY)
    }
    
    for element in elementsSortedByYCoordinate[1..<elementsSortedByYCoordinate.count] {
      setNewPoint(calculateNewPoint(element), forElement: element)
      previousElement = element
    }
  }
  
  func equalHorizontalSpace(_ elements: [SquareElement]) {
    guard !elements.isEmpty else { return }
    
    let containingRect = containingRectFor(elements)
    
    let n = CGFloat(elements.count)
    let combinedConceptWidth = elements.reduce(0, { (acc, concept) in return acc + concept.rect.width })
    let equalHorizontalSpacing: CGFloat = (containingRect.width - combinedConceptWidth) / (n - 1)
    
    let conceptsSortedByXCoordinate = elements.sorted(by: compareByMinCenterX)
    
    var previousConcept = conceptsSortedByXCoordinate[0]
    for element in conceptsSortedByXCoordinate[1..<conceptsSortedByXCoordinate.count] {
      let newX = (element.rect.width / 2) + equalHorizontalSpacing + (previousConcept.rect.width / 2) + previousConcept.point.x
      let newPoint = NSMakePoint(newX, element.point.y)
      
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
    let minX = (elements.map { $0.rect.origin.x }).min()!
    let minY = (elements.map { $0.rect.origin.y }).min()!
    let maxX = (elements.map { $0.rect.maxX }).max()!
    let maxY = (elements.map { $0.rect.maxY }).max()!
    return NSMakeRect(minX, minY, maxX - minX, maxY - minY)
  }
}
