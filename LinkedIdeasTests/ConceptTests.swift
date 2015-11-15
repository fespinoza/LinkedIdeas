//
//  ConceptTest.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 14/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class ConceptTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testEditingFalseByDefault() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let concept = Concept(point: NSPoint(x: 3.0, y: 30.0))
    XCTAssertEqual(concept.editing, false)
  }
  
}
