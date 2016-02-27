//
//  ElementTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 30/01/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class ElementTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testEditingFalseByDefault() {
    let element = Element()
    XCTAssertEqual(element.editing, false)
  }
  
}
