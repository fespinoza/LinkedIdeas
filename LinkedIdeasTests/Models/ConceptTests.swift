//
//  ConceptTests.swift
//  LinkedIdeasTests
//
//  Created by Felipe Espinoza Castillo on 21/08/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class ConceptTests: XCTestCase {
  var concept: Concept!

  override func setUp() {
    super.setUp()
    concept = Concept(stringValue: "hello world", centerPoint: CGPoint(x: 100, y: 200))
  }

  func testUpdateWidthDoesntChangeOriginPoint() {
    let previousArea = concept.area

    concept.updateWidth(withDifference: 20)

    let newArea = concept.area
    XCTAssertEqual(newArea.origin, previousArea.origin)
  }

  func testUpdateWidthChangesWidthAccordingly() {
    concept.mode = .modifiedWidth(width: 50)
    let previousArea = concept.area

    concept.updateWidth(withDifference: 20)

    let newArea = concept.area
    XCTAssertEqual(newArea.width, previousArea.width + 20)
  }

  func testWupdateWidthFromLeftSideDoesNotChangeMaxXValue() {
    let previousArea = concept.area

    concept.updateWidth(withDifference: 20, fromLeft: true)

    let newArea = concept.area
    XCTAssertEqual(newArea.maxX, previousArea.maxX)
  }

  func testUpdateWidthFromLeftChangesWidthAccordingly() {
    let previousArea = concept.area

    concept.updateWidth(withDifference: 20, fromLeft: true)

    let newArea = concept.area
    XCTAssertEqual(newArea.width, previousArea.width + 20)
  }
}
