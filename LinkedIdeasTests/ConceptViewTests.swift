//
//  ConceptViewTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 10/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class ConceptViewTests: XCTestCase {
  func testSavingAConcept() {
    // given
    let canvas = TestCanvas()
    let concept = Concept(point: NSMakePoint(20, 30))
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    
    // when
    conceptView.typeText("foo bar 123")
    conceptView.pressEnterKey()
    
    // then
    XCTAssertNil(canvas.newConcept)
    XCTAssertEqual(canvas.concepts.count, 1)
    XCTAssertEqual(conceptView.editingString(), false)
    XCTAssertEqual(concept.stringValue, "foo bar 123")
  }
  
  func testTextFieldBounds() {
    // given
    let canvas = TestCanvas()
    let concept = Concept(point: NSMakePoint(20, 30))
    
    // when
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    let relativeCenterPointForConceptView = conceptView.convertPoint(conceptView.bounds.center, fromView: nil)
    
    // then
    XCTAssertEqual(conceptView.textField.bounds.center, relativeCenterPointForConceptView)
  }
}