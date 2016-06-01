//
//  ConceptTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 10/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class ConceptTests: XCTestCase {
  func testRectWithoutStringValue() {
    // given
    let point = NSPoint(x: 60, y: 400)
    let concept = Concept(point: point)
    
    // then
    XCTAssertEqual(concept.rect, NSRect(center: point, size: NSMakeSize(60, 20)))
  }
  
  func testRectWithStringValue() {
    // given
    let point = NSPoint(x: 60, y: 400)
    let stringValue = "everything is..."
    let concept = Concept(stringValue: stringValue, point: point)
    var stringSize = stringValue.sizeWithAttributes(nil)
    stringSize.width  += 10
    stringSize.height += 10
    
    // then
    XCTAssert(concept.rect.size.width > 60)
    XCTAssertEqual(concept.rect, NSRect(center: point, size: stringSize))
  }
  
  func testRectWithMultiLineStringValue() {
    // given
    let point = NSPoint(x: 60, y: 400)
    let stringValue = "everything is...\nAWESOME!"
    let concept = Concept(stringValue: stringValue, point: point)
    var stringSize = stringValue.sizeWithAttributes(nil)
    stringSize.width  += 10
    stringSize.height += 10
    
    // then
    XCTAssertEqual(concept.rect, NSRect(center: point, size: stringSize))
  }
}
