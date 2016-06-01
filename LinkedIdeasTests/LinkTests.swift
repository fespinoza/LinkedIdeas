
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
    let concept1 = Concept(point: NSMakePoint(20, 30))
    let concept2 = Concept(point: NSMakePoint(120, 130))
    
    // when
    let link = Link(origin: concept1, target: concept2)
    
    // then
    XCTAssertEqual(link.rect, NSMakeRect(20, 30, 100, 100))
  }
  
  func testRectWhenConceptsAreHorizontallyAligned() {
    // given
    let concept1 = Concept(point: NSMakePoint(300, 130))
    let concept2 = Concept(point: NSMakePoint(120, 130))
    
    // when
    let link = Link(origin: concept1, target: concept2)
    
    // then
    XCTAssertEqual(link.rect, NSMakeRect(120, 120, 180, 20))
  }
  
  func testRectWhenConceptsAreVerticallyAligned() {
    // given
    let concept1 = Concept(point: NSMakePoint(300, 50))
    let concept2 = Concept(point: NSMakePoint(300, 200))
    
    // when
    let link = Link(origin: concept1, target: concept2)
    
    // then
    XCTAssertEqual(link.rect, NSMakeRect(290, 50, 20, 150))
  }
  
  func testRectWhenConceptsAreAlmostVerticallyAligned() {
    // given
    let concept1 = Concept(point: NSMakePoint(305, 50))
    let concept2 = Concept(point: NSMakePoint(300, 200))
    
    // when
    let link = Link(origin: concept1, target: concept2)
    
    // then
    XCTAssertEqual(link.rect, NSMakeRect(290, 50, 20, 150))
  }
  
}
