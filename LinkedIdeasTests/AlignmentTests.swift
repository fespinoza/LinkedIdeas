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

  func setNewPoint(_ newPoint: NSPoint) {
    self.point = newPoint
  }
}

struct AlignmentTestsFixtures {
  static var semiVerticalAligmentElements: [SquareElement] {
    return [
      TestConcept(point: NSPoint(x: 100, y: 210), size: NSSize(width: 60, height: 20)),
      TestConcept(point: NSPoint(x: 150, y: 100), size: NSSize(width: 50, height: 25)),
      TestConcept(point: NSPoint(x: 90, y: 300), size: NSSize(width: 100, height: 20))
    ]
  }

  static var semiHorizontalAligmentElements: [SquareElement] {
    return [
      TestConcept(point: NSPoint(x: 100, y: 210), size: NSSize(width: 60, height: 20)),
      TestConcept(point: NSPoint(x: 200, y: 200), size: NSSize(width: 50, height: 25)),
      TestConcept(point: NSPoint(x: 120, y: 200), size: NSSize(width: 100, height: 20))
    ]
  }
}

struct TestAlignmentFunctions: AlignmentFunctions {}

// helpers

func maxX(_ rect: NSRect) -> CGFloat {
  return rect.origin.x + rect.size.width
}

func maxY(_ rect: NSRect) -> CGFloat {
  return rect.origin.y + rect.size.height
}

func verticalDistanceBetween(_ elementA: SquareElement, _ elementB: SquareElement) -> CGFloat {
  return abs(elementA.point.y - elementB.point.y) - (elementA.rect.height + elementB.rect.height) / 2
}

func horizontalDistanceBetween(_ elementA: SquareElement, _ elementB: SquareElement) -> CGFloat {
  return abs(elementA.point.x - elementB.point.x) - (elementA.rect.width + elementB.rect.width) / 2
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
    XCTAssertEqual(concepts[0].point, NSPoint(x: 100, y: 201.25))
    XCTAssertEqual(concepts[1].point, NSPoint(x: 150, y: 100))
    XCTAssertEqual(concepts[2].point, NSPoint(x: 90, y: 300))
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
    XCTAssertEqual(concepts[0].point, NSPoint(x: 100, y: 210))
    XCTAssertEqual(concepts[1].point, NSPoint(x: 200, y: 200))
    XCTAssertEqual(concepts[2].point, NSPoint(x: 152.5, y: 200))
    XCTAssertEqual(
      horizontalDistanceBetween(concepts[2], concepts[1]),
      horizontalDistanceBetween(concepts[2], concepts[0])
    )
  }
}
