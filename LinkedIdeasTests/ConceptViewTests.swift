//
//  ConceptViewTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 10/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class TestCanvas: Canvas {
  var newConcept: Concept?
  var newConceptView: ConceptView?
  var concepts: [Concept] = [Concept]()
  var conceptViews: [String: ConceptView] = [String: ConceptView]()
  
  init(concepts: [Concept]? = nil) {
    if let concepts = concepts {
      self.concepts = concepts
      for concept in concepts { addConceptView(concept) }
    }
  }
  
  // MARK: - CanvasView
  func addConceptView(concept: Concept) {
    let conceptView = ConceptView(concept: concept, canvas: self)
    conceptViews[concept.identifier] = conceptView
  }
  
  func saveConcept(conceptView: ConceptView) {
    newConcept = nil
    newConceptView = nil
    let concept = conceptView.concept
    concepts.append(concept)
    conceptViews[concept.identifier] = conceptView
  }
  
  // MARK: - ClickableView
  
  func doubleClick(point: NSPoint) {}
  
  // MARK: - CanvasActions
  func drawConceptViews() {}
  func drawConceptView(concept: Concept) {}
  
  func deselectConcepts() {}
  func removeNonSavedConcepts() {}
  
  func markConceptsAsNotEditable() {
    for concept in concepts {
      concept.isEditable = false
      conceptViews[concept.identifier]!.toggleTextFieldEditMode()
    }
  }
  
  func createConceptAt(point: NSPoint) {
    newConcept = Concept(point: point)
    newConcept?.isEditable = true
    newConceptView = ConceptView(concept: newConcept!, canvas: self)
  }
}

class ConceptViewTests: XCTestCase {
  func testSavingAConcept() {
    // given
    let canvas = TestCanvas()
    let concept = Concept(point: NSMakePoint(20, 30))
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    
    // when
    conceptView.typeText("foo bar 123")
    conceptView.pressEnterKey()
    conceptView.drawRect(conceptView.bounds)
    
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
    
    // then
    XCTAssertEqual(conceptView.textField.bounds, NSMakeRect(0, 0, 60, 20))
  }
  
  func testTextFieldBecomesFirstResponder() {
    // given
    let canvas = TestCanvas()
    let concept = Concept(point: NSMakePoint(20, 30))
    concept.isEditable = true
    
    // when
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    conceptView.drawRect(conceptView.bounds)
    
    // then
    XCTAssertEqual(conceptView.isTextFieldFocused, true)
  }
  
  func testClickOnConceptView() {
    // given
    let canvas = TestCanvas()
    let concept = Concept(point: NSMakePoint(20, 30))
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    
    // when
    conceptView.click(NSMakePoint(40, 20))
    
    // then
    XCTAssertEqual(concept.isSelected, true)
  }
  
  func testClickOnConceptViewWhenThereIsAnotherOnEditMode() {
    XCTFail("implement me next")
  }
  
  func testDoubleClickOnConceptView() {
    // given
    let canvas = TestCanvas()
    let concept = Concept(point: NSMakePoint(20, 30))
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    
    // when
    conceptView.doubleClick(NSMakePoint(40, 20))
    
    // then
    XCTAssertEqual(concept.isEditable, true)
    XCTAssertEqual(conceptView.editingString(), true)
  }
}