//
//  Alignment.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 25/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

// helpers

func maxX(_ rect: NSRect) -> CGFloat {
  return rect.origin.x + rect.size.width
}

func maxY(_ rect: NSRect) -> CGFloat {
  return rect.origin.y + rect.size.height
}

func verticalDistanceBetween(_ elementA: NSRect, _ elementB: NSRect) -> CGFloat {
  return abs(elementA.center.y - elementB.center.y) - (elementA.height + elementB.height) / 2
}

func horizontalDistanceBetween(_ elementA: NSRect, _ elementB: NSRect) -> CGFloat {
  return abs(elementA.center.x - elementB.center.x) - (elementA.width + elementB.width) / 2
}

class RectAlignmentsTests: XCTestCase {
  struct Fixtures {
    static var semiVerticalAligmentElements: [NSRect] {
      return [
        NSRect(center: NSPoint(x: 100, y: 210), size: NSSize(width: 60, height: 20)),
        NSRect(center: NSPoint(x: 150, y: 100), size: NSSize(width: 50, height: 25)),
        NSRect(center: NSPoint(x: 90, y: 300), size: NSSize(width: 100, height: 20))
      ]
    }

    static var semiHorizontalAligmentElements: [NSRect] {
      return [
        NSRect(center: NSPoint(x: 100, y: 210), size: NSSize(width: 60, height: 20)),
        NSRect(center: NSPoint(x: 200, y: 200), size: NSSize(width: 50, height: 25)),
        NSRect(center: NSPoint(x: 120, y: 200), size: NSSize(width: 100, height: 20))
      ]
    }
  }

  func testCenterAlignConcepts() {
    // given
    let rects = Fixtures.semiVerticalAligmentElements

    // when
    let alignedRects = RectAlignments.verticallyCenterAlign(rects: rects)

    // then
    XCTAssertEqual(alignedRects[0].center.x, alignedRects[1].center.x)
    XCTAssertEqual(alignedRects[1].center.x, alignedRects[2].center.x)
  }

  func testLeftAlignConcepts() {
    // given
    let rects = Fixtures.semiVerticalAligmentElements

    // when
    let alignedRects = RectAlignments.verticallyLeftAlign(rects: rects)

    // then
    XCTAssertEqual(alignedRects[0].minX, alignedRects[1].minX)
    XCTAssertEqual(alignedRects[1].minX, alignedRects[2].minX)
  }

  func testRightAlignConcepts() {
    // given
    let rects = Fixtures.semiVerticalAligmentElements

    // when
    let alignedRects = RectAlignments.verticallyRightAlign(rects: rects)

    // then
    XCTAssertEqual(maxX(alignedRects[0]), maxX(alignedRects[1]))
    XCTAssertEqual(maxX(alignedRects[1]), maxX(alignedRects[2]))
  }

  func testHorizontallyAlignConcepts() {
    // given
    let rects = Fixtures.semiHorizontalAligmentElements

    // when
    let alignedRects = RectAlignments.horizontallyCenterAlign(rects: rects)

    // then
    XCTAssertEqual(alignedRects[0].center.y, alignedRects[1].center.y)
    XCTAssertEqual(alignedRects[1].center.y, alignedRects[2].center.y)
  }

  func testEquallyVerticalSpaceConcepts() {
    // given
    let rects = Fixtures.semiVerticalAligmentElements

    // when
    let alignedRects = RectAlignments.equalVerticalSpace(rects: rects)

    // then
    XCTAssertEqual(alignedRects[0].center, NSPoint(x: 100, y: 201.25))
    XCTAssertEqual(alignedRects[1].center, NSPoint(x: 150, y: 100))
    XCTAssertEqual(alignedRects[2].center, NSPoint(x: 90, y: 300))
    XCTAssertEqual(
      RectAlignments.containingRect(forRects: rects),
      RectAlignments.containingRect(forRects: alignedRects)
    )
    XCTAssertEqual(
      verticalDistanceBetween(alignedRects[0], alignedRects[1]),
      verticalDistanceBetween(alignedRects[0], alignedRects[2])
    )
  }

  func testEquallyHorizontalSpaceConcepts() {
    // given
    let rects = Fixtures.semiHorizontalAligmentElements

    // when
    let alignedRects = RectAlignments.equalHorizontalSpace(rects: rects)

    // then
    XCTAssertEqual(alignedRects[0].center, NSPoint(x: 100, y: 210))
    XCTAssertEqual(alignedRects[1].center, NSPoint(x: 200, y: 200))
    XCTAssertEqual(alignedRects[2].center, NSPoint(x: 152.5, y: 200))
    XCTAssertEqual(
      horizontalDistanceBetween(alignedRects[2], alignedRects[1]),
      horizontalDistanceBetween(alignedRects[2], alignedRects[0])
    )
  }
}
