//
//  LinkTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class LinkTests: XCTestCase {

  func testRectNormalCase() {
    // given
    let concept1 = Concept(centerPoint: CGPoint(x: 20, y: 30))
    let concept2 = Concept(centerPoint: CGPoint(x: 120, y: 130))

    // when
    let link = Link(origin: concept1, target: concept2)

    // then
    XCTAssertEqual(link.area, CGRect(x: 20, y: 30, width: 100, height: 100))
  }

  func testRectWhenConceptsAreHorizontallyAligned() {
    // given
    let concept1 = Concept(centerPoint: CGPoint(x: 300, y: 130))
    let concept2 = Concept(centerPoint: CGPoint(x: 120, y: 130))

    // when
    let link = Link(origin: concept1, target: concept2)

    // then
    XCTAssertEqual(link.area, CGRect(x: 120, y: 120, width: 180, height: 20))
  }

  func testRectWhenConceptsAreVerticallyAligned() {
    // given
    let concept1 = Concept(centerPoint: CGPoint(x: 300, y: 50))
    let concept2 = Concept(centerPoint: CGPoint(x: 300, y: 200))

    // when
    let link = Link(origin: concept1, target: concept2)

    // then
    XCTAssertEqual(link.area, CGRect(x: 290, y: 50, width: 20, height: 150))
  }

  func testRectWhenConceptsAreAlmostVerticallyAligned() {
    // given
    let concept1 = Concept(centerPoint: CGPoint(x: 305, y: 50))
    let concept2 = Concept(centerPoint: CGPoint(x: 300, y: 200))

    // when
    let link = Link(origin: concept1, target: concept2)

    // then
    XCTAssertEqual(link.area, CGRect(x: 290, y: 50, width: 20, height: 150))
  }

}
