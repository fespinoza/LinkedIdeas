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
  let canvas = CanvasView(frame: NSMakeRect(20, 20, 600, 400))
  
  func testSavingAConcept() {
    // given
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
    let concept = Concept(point: NSMakePoint(20, 30))

    // when
    let conceptView = ConceptView(concept: concept, canvas: canvas)

    // then
    XCTAssertEqual(conceptView.textField.bounds, NSMakeRect(0, 0, 60, 20))
  }

  func testTextFieldBecomesFirstResponder() {
    // given
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
    let concept = Concept(point: NSMakePoint(20, 30))
    let conceptView = ConceptView(concept: concept, canvas: canvas)

    // when
    conceptView.click(NSMakePoint(40, 20))

    // then
    XCTAssertEqual(concept.isSelected, true)
  }

  func testClickOnConceptViewWhenThereIsAnotherOnEditMode() {
    // given
    let concept1 = Concept(point: NSMakePoint(1, 20))
    let concept2 = Concept(point: NSMakePoint(100, 200))
    concept1.isEditable = true
    canvas.concepts.append(concept1)
    canvas.concepts.append(concept2)
    canvas.drawConceptViews()
    let conceptView2 = canvas.conceptViewFor(concept2)

    // when
    canvas.click(NSMakePoint(20, 30))
    conceptView2.click(NSMakePoint(20, 30))

    // then
    XCTAssertEqual(concept1.isEditable, false)
    XCTAssertEqual(concept1.isSelected, false)
    XCTAssertEqual(concept2.isSelected, true)
    XCTAssertNil(canvas.newConcept)
    XCTAssertNil(canvas.newConceptView)
  }

  func testDoubleClickOnConceptView() {
    // given
    let concept = Concept(point: NSMakePoint(20, 30))
    let conceptView = ConceptView(concept: concept, canvas: canvas)

    // when
    conceptView.doubleClick(NSMakePoint(40, 20))

    // then
    XCTAssertEqual(concept.isEditable, true)
    XCTAssertEqual(conceptView.editingString(), true)
  }

  func testDraggingAConceptView() {
    // given
    let conceptPointInCanvas = NSMakePoint(200, 300)
    
    let concept = Concept(point: conceptPointInCanvas)
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    
    let originalFrame = conceptView.frame
    
    let dragToPointInWindow = NSMakePoint(250, 150)
    let dragToPointInCanvas = canvas.pointInCanvasCoordinates(dragToPointInWindow)

    // when
    conceptView.click(conceptPointInCanvas)
    conceptView.dragTo(dragToPointInCanvas)
    
    let afterDragFrame = conceptView.frame

    // then
    XCTAssert(originalFrame != afterDragFrame)
    XCTAssertEqual(afterDragFrame.center, dragToPointInCanvas)
  }
  
  func testDraggingAConceptViewWhenLinksModeDoesNotChangePosition() {
    // given
    let concept = Concept(point: NSMakePoint(200, 300))
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    let originalFrame = conceptView.frame
    let dragToPointInWindow = NSMakePoint(450, 100)
    canvas.mode = Mode.Links
    
    // when
    conceptView.click(NSMakePoint(200, 300))
    conceptView.dragTo(dragToPointInWindow)
    let afterDragFrame = conceptView.frame
    
    // then
    XCTAssertEqual(originalFrame, afterDragFrame)
  }
  
  func testPressintEscapeWhenEditingAConceptAlreadySaved() {
    // given
    let concept = Concept(stringValue: "foo", point: NSMakePoint(200, 300))
    concept.isEditable = true
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    canvas.concepts = [concept]
    canvas.conceptViews = [concept.identifier: conceptView]
    
    // when
    conceptView.typeText("another text")
    conceptView.cancelEdition()
    canvas.drawRect(canvas.bounds)
    
    // then
    XCTAssertEqual(concept.stringValue, "foo")
    XCTAssertEqual(concept.isEditable, false)
    XCTAssertEqual(conceptView.editingString(), false)
  }
  
  func testPressintEscapeWhenEditingANewConcept() {
    // given
    let concept = Concept(stringValue: "foo", point: NSMakePoint(200, 300))
    concept.isEditable = true
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    canvas.newConcept = concept
    canvas.newConceptView = conceptView
    
    // when
    conceptView.typeText("another text")
    conceptView.cancelEdition()
    canvas.drawRect(canvas.bounds)
    
    // then
    XCTAssertNil(canvas.newConcept)
    XCTAssertNil(canvas.newConceptView)
    XCTAssertEqual(canvas.subviews.count, 0)
  }
}
