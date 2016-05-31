//
//  AligmentFunctions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/05/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol AlignmentFunctions {
  func setNewPoint(newPoint: NSPoint, forElement element: SquareElement)
}

extension AlignmentFunctions {
  // MARK: - SquareElement
  func compareByMaxRectX(p1: SquareElement, p2: SquareElement) -> Bool {
    return p1.rect.maxX > p2.rect.maxX
  }
  
  func compareByMinRectX(p1: SquareElement, p2: SquareElement) -> Bool {
    return p1.rect.origin.x < p2.rect.origin.x
  }
  
  func compareByMinCenterX(p1: SquareElement, p2: SquareElement) -> Bool {
    return p1.point.x < p2.point.x
  }
  
  func compareByMinCenterY(p1: SquareElement, p2: SquareElement) -> Bool {
    return p1.point.y < p2.point.y
  }
  
  // MARK: - Alignment Functions
  func verticallyCenterAlign(elements: [SquareElement]) {
    let sortedConcepts = elements.sort(compareByMinCenterX)
    let minimunXCoordinate = sortedConcepts.first!.point.x
    
    func calculateNewPoint(element: SquareElement) -> NSPoint {
      return NSMakePoint(minimunXCoordinate, element.point.y)
    }
    
    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }
  
  func verticallyLeftAlign(elements: [SquareElement]) {
    let sortedConcepts = elements.sort(compareByMinRectX)
    let minimunXCoordinate = sortedConcepts.first!.rect.origin.x
    
    func calculateNewPoint(element: SquareElement) -> NSPoint {
      let newX: CGFloat = minimunXCoordinate + element.rect.width / 2
      return NSMakePoint(newX, element.point.y)
    }
    
    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }
  
  func verticallyRightAlign(elements: [SquareElement]) {
    let sortedConcepts = elements.sort(compareByMaxRectX)
    let minimunXCoordinate = sortedConcepts.first!.rect.maxX
    
    func calculateNewPoint(element: SquareElement) -> NSPoint {
      let newX: CGFloat = minimunXCoordinate - element.rect.width / 2
      return NSMakePoint(newX, element.point.y)
    }
    
    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }
  
  func horizontallyAlign(elements: [SquareElement]) {
    let averageYCoordinate: CGFloat = elements.minElement(compareByMinCenterX)!.point.y
    
    func calculateNewPoint(element: SquareElement) -> NSPoint {
      return NSMakePoint(element.point.x, averageYCoordinate)
    }
    
    updateElementPoints(elements, newPointCalculator: calculateNewPoint)
  }
  
  func equalVerticalSpace(elements: [SquareElement]) {
    let containingRect = containingRectFor(elements)
    
    let n = CGFloat(elements.count)
    let combinedConceptHeight = elements.reduce(0, combine: { (acc, concept) in return acc + concept.rect.height })
    let equalVerticalSpacing: CGFloat = (containingRect.height - combinedConceptHeight) / (n - 1)
    
    let elementsSortedByYCoordinate = elements.sort(compareByMinCenterY)
    
    var previousElement = elementsSortedByYCoordinate[0]
    
    func calculateNewPoint(element: SquareElement) -> NSPoint {
      let newY = (element.rect.height / 2) + equalVerticalSpacing + (previousElement.rect.height / 2) + previousElement.point.y
      return NSMakePoint(element.point.x, newY)
    }
    
    for element in elementsSortedByYCoordinate[1..<elementsSortedByYCoordinate.count] {
      setNewPoint(calculateNewPoint(element), forElement: element)
      previousElement = element
    }
  }
  
  func equalHorizontalSpace(elements: [SquareElement]) {
    let containingRect = containingRectFor(elements)
    
    let n = CGFloat(elements.count)
    let combinedConceptWidth = elements.reduce(0, combine: { (acc, concept) in return acc + concept.rect.width })
    let equalHorizontalSpacing: CGFloat = (containingRect.width - combinedConceptWidth) / (n - 1)
    
    let conceptsSortedByXCoordinate = elements.sort(compareByMinCenterX)
    
    var previousConcept = conceptsSortedByXCoordinate[0]
    for element in conceptsSortedByXCoordinate[1..<conceptsSortedByXCoordinate.count] {
      let newX = (element.rect.width / 2) + equalHorizontalSpacing + (previousConcept.rect.width / 2) + previousConcept.point.x
      let newPoint = NSMakePoint(newX, element.point.y)
      
      setNewPoint(newPoint, forElement: element)
    
      previousConcept = element
    }
  }
  
  // MARK: - Utilities
  func setNewPoint(newPoint: NSPoint, forElement element: SquareElement) {
    element.point = newPoint
  }
  
  func updateElementPoints(elements: [SquareElement], newPointCalculator: (SquareElement) -> NSPoint) {
    for element in elements {
      setNewPoint(newPointCalculator(element), forElement: element)
    }
  }
  
  func containingRectFor(elements: [SquareElement]) -> NSRect {
    let minX = (elements.map { $0.rect.origin.x }).minElement()!
    let minY = (elements.map { $0.rect.origin.y }).minElement()!
    let maxX = (elements.map { $0.rect.maxX }).maxElement()!
    let maxY = (elements.map { $0.rect.maxY }).maxElement()!
    return NSMakeRect(minX, minY, maxX - minX, maxY - minY)
  }
}
