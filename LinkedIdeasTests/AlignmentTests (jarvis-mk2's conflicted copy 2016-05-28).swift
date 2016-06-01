//
//  Alignment.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 25/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

protocol SquareElement {
  var point: NSPoint { get set }
  var minimalRect: NSRect { get set }
  
  mutating func setNewPoint(newPoint: NSPoint)
}

class TestConcept: SquareElement {
  var point: NSPoint
  var minimalRect: NSRect
  
  init(point: NSPoint, minimalRect: NSRect) {
    self.point = point
    self.minimalRect = minimalRect
  }
  
  init(point: NSPoint, size: NSSize) {
    self.point = point
    self.minimalRect = NSRect(center: point, size: size)
  }
  
  func setNewPoint(newPoint: NSPoint) {
    self.point = newPoint
  }
}

struct AlignmentTestsFixtures {
  static let semiVerticalAligmentElements: [SquareElement] = [
    TestConcept(point: NSMakePoint(100, 210), size: NSMakeSize(60, 20)),
    TestConcept(point: NSMakePoint(200, 200), size: NSMakeSize(50, 25)),
    TestConcept(point: NSMakePoint(120, 200), size: NSMakeSize(100, 20))
  ]
}

struct AligmentFunctions {
  static func verticallyCenterAlign(elements: [SquareElement]) {
    let sortedConcepts = elements.sort { (p1: SquareElement, p2: SquareElement) -> Bool in return p1.point.x < p2.point.x }
    let minimunXCoordinate = sortedConcepts.first!.point.x
    
    for var element in elements {
      let verticallyCenterAlignedPoint = NSMakePoint(minimunXCoordinate, element.point.y)
      element.setNewPoint(verticallyCenterAlignedPoint)
    }
  }
  
  static func verticallyLeftAlign(elements: [SquareElement]) {
    let sortedConcepts = elements.sort { (p1: SquareElement, p2: SquareElement) -> Bool in return p1.minimalRect.origin.x < p2.minimalRect.origin.x }
    let minimunXCoordinate = sortedConcepts.first!.minimalRect.origin.x
    
    for var element in elements {
      let newX: CGFloat = minimunXCoordinate + element.minimalRect.width / 2
      let verticallyLeftAlignedPoint = NSMakePoint(newX, element.point.y)
      element.setNewPoint(verticallyLeftAlignedPoint)
    }
  }
}

class AlignmentFunctionTests: XCTestCase {
  
  override func setUp() { super.setUp() }
  
  override func tearDown() { super.tearDown() }
  
  func testCenterAlignConcepts() {
    // given
    let concepts = AlignmentTestsFixtures.semiVerticalAligmentElements
    
    // when
    AligmentFunctions.verticallyCenterAlign(concepts)
    
    // then
    XCTAssertEqual(concepts[0].point.x, concepts[1].point.x)
    XCTAssertEqual(concepts[1].point.x, concepts[2].point.x)
  }
  
  func testLeftAlignConcepts() {
    // given
    let concepts = AlignmentTestsFixtures.semiVerticalAligmentElements
    
    // when
    AligmentFunctions.verticallyLeftAlign(concepts)
    
    // then
    XCTAssertEqual(concepts[0].minimalRect.minX, concepts[1].minimalRect.minX)
    XCTAssertEqual(concepts[1].minimalRect.minX, concepts[2].minimalRect.minX)
  }
}
