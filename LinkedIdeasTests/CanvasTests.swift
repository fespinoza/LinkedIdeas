//
//  CanvasProtocolTests.swift
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

class CanvasTests: XCTestCase {
  func testClickOnEmptyCanvas() {
    // given
    let canvas = TestCanvas()
    
    // when
    let clickedPoint = NSMakePoint(20, 60)
    canvas.click(clickedPoint)
    
    // then
    let newConcept: Concept? = canvas.newConcept
    let newConceptView: ConceptView? = canvas.newConceptView
    
    XCTAssertNotNil(newConcept)
    XCTAssertEqual(newConcept!.point, clickedPoint)
    XCTAssertEqual(newConcept!.isEditable, true)
    XCTAssertEqual(newConceptView!.editingString(), true)
    XCTAssertEqual(newConceptView!.textFieldSize, NSMakeSize(60, 20))
  }
  
  func testClickingOnCanvasWhenOtherConceptIsEditable() {
    // given
    let concept1 = Concept(point: NSMakePoint(1, 20))
    let concept2 = Concept(point: NSMakePoint(100, 200))
    let canvas = TestCanvas(concepts: [concept1, concept2])
    
    // when
    canvas.click(NSMakePoint(20, 60))
    
    // then
    XCTAssertEqual(canvas.newConceptView!.editingString(), true)
    XCTAssertEqual(canvas.conceptViews[concept1.identifier]!.editingString(), false)
    XCTAssertEqual(canvas.conceptViews[concept1.identifier]!.editingString(), false)
  }
}
