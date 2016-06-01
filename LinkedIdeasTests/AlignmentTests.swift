//
//  Alignment.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 25/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class TestConcept: SquareElement {
  var point: NSPoint
  var size: NSSize
  var rect: NSRect {
    return NSRect(center: point, size: size)
  }
  
  init(point: NSPoint, size: NSSize) {
    self.point = point
    self.size = size
  }
  
  func setNewPoint(newPoint: NSPoint) {
    self.point = newPoint
  }
}

struct AlignmentTestsFixtures {
  static var semiVerticalAligmentElements: [SquareElement] {
    return [
      TestConcept(point: NSMakePoint(100, 210), size: NSMakeSize(60, 20)),
      TestConcept(point: NSMakePoint(150, 100), size: NSMakeSize(50, 25)),
      TestConcept(point: NSMakePoint(90, 300), size: NSMakeSize(100, 20))
    ]
  }
  
  static var semiHorizontalAligmentElements: [SquareElement] {
    return [
      TestConcept(point: NSMakePoint(100, 210), size: NSMakeSize(60, 20)),
      TestConcept(point: NSMakePoint(200, 200), size: NSMakeSize(50, 25)),
      TestConcept(point: NSMakePoint(120, 200), size: NSMakeSize(100, 20))
    ]
  }
}

struct TestAlignmentFunctions: AlignmentFunctions {}

// helpers

func maxX(rect: NSRect) -> CGFloat {
  return rect.origin.x + rect.size.width
}

func maxY(rect: NSRect) -> CGFloat {
  return rect.origin.y + rect.size.height
}

func verticalDistanceBetween(a: SquareElement, _ b: SquareElement) -> CGFloat {
  return abs(a.point.y - b.point.y) - (a.rect.height + b.rect.height) / 2
}

func horizontalDistanceBetween(a: SquareElement, _ b: SquareElement) -> CGFloat {
  return abs(a.point.x - b.point.x) - (a.rect.width + b.rect.width) / 2
}

class AlignmentFunctionTests: XCTestCase {
  let aligmentController = TestAlignmentFunctions()
  
  func testCenterAlignConcepts() {
    // given
    let concepts = AlignmentTestsFixtures.semiVerticalAligmentElements
    
    // when
    aligmentController.verticallyCenterAlign(concepts)
    
    // then
    XCTAssertEqual(concepts[0].point.x, concepts[1].point.x)
    XCTAssertEqual(concepts[1].point.x, concepts[2].point.x)
  }
  
  func testLeftAlignConcepts() {
    // given
    let concepts = AlignmentTestsFixtures.semiVerticalAligmentElements
    
    // when
    aligmentController.verticallyLeftAlign(concepts)
    
    // then
    XCTAssertEqual(concepts[0].rect.minX, concepts[1].rect.minX)
    XCTAssertEqual(concepts[1].rect.minX, concepts[2].rect.minX)
  }
  
  func testRightAlignConcepts() {
    // given
    let concepts = AlignmentTestsFixtures.semiVerticalAligmentElements
    
    // when
    aligmentController.verticallyRightAlign(concepts)
    
    // then
    XCTAssertEqual(maxX(concepts[0].rect), maxX(concepts[1].rect))
    XCTAssertEqual(maxX(concepts[1].rect), maxX(concepts[2].rect))
  }

  func testHorizontallyAlignConcepts() {
    // given
    let concepts = AlignmentTestsFixtures.semiHorizontalAligmentElements
    
    // when
    aligmentController.horizontallyAlign(concepts)
    
    // then
    XCTAssertEqual(concepts[0].point.y, concepts[1].point.y)
    XCTAssertEqual(concepts[1].point.y, concepts[2].point.y)
  }
  
  func testEquallyVerticalSpaceConcepts() {
    // given
    let concepts = AlignmentTestsFixtures.semiVerticalAligmentElements
    
    // when
    aligmentController.equalVerticalSpace(concepts)
    
    // then
    XCTAssertEqual(concepts[0].point, NSMakePoint(100, 201.25))
    XCTAssertEqual(concepts[1].point, NSMakePoint(150, 100))
    XCTAssertEqual(concepts[2].point, NSMakePoint(90, 300))
    XCTAssertEqual(
      verticalDistanceBetween(concepts[0], concepts[1]),
      verticalDistanceBetween(concepts[0], concepts[2])
    )
  }
  
  func testEquallyHorizontalSpaceConcepts() {
    // given
    let concepts = AlignmentTestsFixtures.semiHorizontalAligmentElements
    
    // when
    aligmentController.equalHorizontalSpace(concepts)
    
    // then
    XCTAssertEqual(concepts[0].point, NSMakePoint(100, 210))
    XCTAssertEqual(concepts[1].point, NSMakePoint(200, 200))
    XCTAssertEqual(concepts[2].point, NSMakePoint(152.5, 200))
    XCTAssertEqual(
      horizontalDistanceBetween(concepts[2], concepts[1]),
      horizontalDistanceBetween(concepts[2], concepts[0])
    )
  }
}
