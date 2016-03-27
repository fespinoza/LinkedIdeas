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
  
  func testMinimalRect() {
    // given
    let concept1 = Concept(point: NSMakePoint(20, 30))
    let concept2 = Concept(point: NSMakePoint(120, 130))
    
    // when
    let link = Link(origin: concept1, target: concept2)
    
    // then
    XCTAssertEqual(link.minimalRect, NSMakeRect(20, 30, 100, 100))
  }
  
}
