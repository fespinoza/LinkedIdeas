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
  let canvas = OldCanvasView(frame: NSMakeRect(20, 20, 600, 400))
  let testDocument = TestDocument()
  
  override func setUp() {
    canvas.document = testDocument
  }
  
  func testSavingAConcept() {
    // given
    let concept = Concept(point: NSMakePoint(20, 30))
    let conceptView = ConceptView(concept: concept, canvas: canvas)

    // when
    conceptView.typeText("foo bar 123")
    conceptView.pressEnterKey()
    conceptView.draw(conceptView.bounds)

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
    conceptView.draw(conceptView.bounds)

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
    testDocument.concepts = [concept1, concept2]
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
    let concept = Concept(stringValue: "old value", point: NSMakePoint(20, 30))
    let conceptView = ConceptView(concept: concept, canvas: canvas)

    // when
    conceptView.doubleClick(NSMakePoint(40, 20))

    // then
    XCTAssertEqual(concept.isEditable, true)
    XCTAssertEqual(conceptView.editingString(), true)
    XCTAssertEqual(conceptView.textField.stringValue, "old value")
  }

  func testDraggingAConceptViewOnSelectMode() {
    // given
    canvas.mode = .Select
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
  
  func testDraggingAConceptViewInAnotherModeDoesNotMoveConceptView() {
    // given
    canvas.mode = .Concepts
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
    XCTAssertEqual(originalFrame.center, afterDragFrame.center)
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
    XCTAssertEqual(originalFrame.center, afterDragFrame.center)
  }
  
  func testPressintEscapeWhenEditingAConceptAlreadySaved() {
    // given
    let concept = Concept(stringValue: "foo", point: NSMakePoint(200, 300))
    concept.isEditable = true
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    testDocument.concepts = [concept]
    canvas.conceptViews = [concept.identifier: conceptView]
    
    // when
    conceptView.typeText("another text")
    conceptView.cancelEdition()
    canvas.draw(canvas.bounds)
    
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
    canvas.draw(canvas.bounds)
    
    // then
    XCTAssertNil(canvas.newConcept)
    XCTAssertNil(canvas.newConceptView)
    XCTAssertEqual(canvas.subviews.count, 0)
  }
  
  func testDeletingAConcept() {
    // given
    let concept1 = Concept(stringValue: "foo", point: NSMakePoint(200, 300))
    let concept2 = Concept(stringValue: "bar", point: NSMakePoint(100, 450))
    let concept3 = Concept(stringValue: "baz", point: NSMakePoint(300, 200))
    let link1 = Link(origin: concept1, target: concept2)
    let link2 = Link(origin: concept3, target: concept1)
    let link3 = Link(origin: concept3, target: concept2)
    testDocument.concepts = [concept1, concept2, concept3]
    testDocument.links = [link1, link2, link3]
    canvas.drawConceptViews()
    canvas.drawLinkViews()
    let conceptView1 = canvas.conceptViewFor(concept1)
    
    // when
    concept1.isSelected = true
    conceptView1.pressDeleteKey()
    
    // then
    XCTAssertEqual(canvas.concepts, [concept2, concept3])
    XCTAssertEqual(canvas.conceptViews.count, 2)
    XCTAssertEqual(canvas.links, [link3])
    XCTAssertEqual(canvas.linkViews.count, 1)
    XCTAssertEqual(canvas.subviews.count, 3)
  }
  
  // Mark: - MultipleSelect tests
  
  func testClickOnConceptAlreadyMultipleSelected() {
    // Given
    let concepts = [
      Concept(stringValue: "foo", point: NSMakePoint(200, 300)),
      Concept(stringValue: "bar", point: NSMakePoint(100, 450)),
      Concept(stringValue: "baz", point: NSMakePoint(300, 200))
    ]
    testDocument.concepts = concepts
    concepts[0].isSelected = true
    concepts[1].isSelected = true
    canvas.mode = .Select
    canvas.drawConceptViews()
    
    // when
    canvas.conceptViewFor(concepts[1]).click(NSMakePoint(20, 10))
    
    // then
    XCTAssertEqual(concepts[0].isSelected, true)
    XCTAssertEqual(concepts[1].isSelected, true)
    XCTAssertEqual(concepts[2].isSelected, false)
  }
  
  func testClickOnAnUnselectedConceptWhenThereAreOthersSelected() {
    // Given
    let concepts = [
      Concept(stringValue: "foo", point: NSMakePoint(200, 300)),
      Concept(stringValue: "bar", point: NSMakePoint(100, 450)),
      Concept(stringValue: "baz", point: NSMakePoint(300, 200))
    ]
    testDocument.concepts = concepts
    concepts[0].isSelected = true
    concepts[1].isSelected = true
    canvas.mode = .Select
    canvas.drawConceptViews()
    
    // when
    canvas.conceptViewFor(concepts[2]).click(NSMakePoint(20, 10))
    
    // then
    XCTAssertEqual(concepts[0].isSelected, false)
    XCTAssertEqual(concepts[1].isSelected, false)
    XCTAssertEqual(concepts[2].isSelected, true)
  }
  
  func testMultipleSelectingAConcept() {
    // Given
    let concepts = [
      Concept(stringValue: "foo", point: NSMakePoint(200, 300)),
      Concept(stringValue: "bar", point: NSMakePoint(100, 450)),
      Concept(stringValue: "baz", point: NSMakePoint(300, 200))
    ]
    testDocument.concepts = concepts
    concepts[0].isSelected = true
    concepts[1].isSelected = true
    canvas.mode = .Select
    canvas.drawConceptViews()
    
    // when
    canvas.conceptViewFor(concepts[2]).shiftClick(NSMakePoint(20, 10))
    
    // then
    XCTAssertEqual(concepts[0].isSelected, true)
    XCTAssertEqual(concepts[1].isSelected, true)
    XCTAssertEqual(concepts[2].isSelected, true)
  }
  
  func testDeselectingElementFromMultipleSelect() {
    // given
    let concepts = [
      Concept(stringValue: "foo", point: NSMakePoint(200, 300)),
      Concept(stringValue: "bar", point: NSMakePoint(100, 450)),
      Concept(stringValue: "baz", point: NSMakePoint(300, 200))
    ]
    testDocument.concepts = concepts
    concepts[0].isSelected = true
    concepts[1].isSelected = true
    canvas.mode = .Select
    canvas.drawConceptViews()
    
    // when
    canvas.conceptViewFor(concepts[1]).shiftClick(NSMakePoint(20, 10))
    
    // then
    XCTAssertEqual(concepts[0].isSelected, true)
    XCTAssertEqual(concepts[1].isSelected, false)
    XCTAssertEqual(concepts[2].isSelected, false)
  }
  
  func testDraggingMultipleSelectedConcepts() {
    // given
    let concepts = [
      Concept(stringValue: "foo", point: NSMakePoint(200, 300)),
      Concept(stringValue: "bar", point: NSMakePoint(100, 450)),
      Concept(stringValue: "baz", point: NSMakePoint(300, 200))
    ]
    testDocument.concepts = concepts
    concepts[0].isSelected = true
    concepts[1].isSelected = true
    canvas.mode = .Select
    canvas.drawConceptViews()
    let conceptViews = concepts.map { canvas.conceptViewFor($0) }
    let conceptViewsOriginalFrames = conceptViews.map { $0.frame }
    
    // when
    conceptViews[1].dragStart(NSMakePoint(200, 450))
    conceptViews[1].dragTo(NSMakePoint(200, 450))
    conceptViews[1].dragEnd(NSMakePoint(200, 450))
    
    // then
    let conceptViewsNewFrames = conceptViews.map { $0.frame }
    XCTAssertNotEqual(conceptViewsOriginalFrames[0], conceptViewsNewFrames[0])
    XCTAssertNotEqual(conceptViewsOriginalFrames[1], conceptViewsNewFrames[1])
    XCTAssertEqual(conceptViewsOriginalFrames[2], conceptViewsNewFrames[2])
  }
  
  func testDraggingConceptNotInMultipleSelect() {
    // given
    let concepts = [
      Concept(stringValue: "foo", point: NSMakePoint(200, 300)),
      Concept(stringValue: "bar", point: NSMakePoint(100, 450)),
      Concept(stringValue: "baz", point: NSMakePoint(300, 200))
    ]
    testDocument.concepts = concepts
    concepts[0].isSelected = true
    concepts[1].isSelected = true
    canvas.mode = .Select
    canvas.drawConceptViews()
    let conceptViews = concepts.map { canvas.conceptViewFor($0) }
    let conceptViewsOriginalFrames = conceptViews.map { $0.frame }
    
    // when
    conceptViews[2].click(NSMakePoint(200, 450))
    conceptViews[2].dragTo(NSMakePoint(200, 450))
    
    // then
    let conceptViewsNewFrames = conceptViews.map { $0.frame }
    XCTAssertEqual(conceptViewsOriginalFrames[0], conceptViewsNewFrames[0])
    XCTAssertEqual(conceptViewsOriginalFrames[1], conceptViewsNewFrames[1])
    XCTAssertNotEqual(conceptViewsOriginalFrames[2], conceptViewsNewFrames[2])
    XCTAssertEqual(concepts[0].isSelected, false)
    XCTAssertEqual(concepts[1].isSelected, false)
    XCTAssertEqual(concepts[2].isSelected, true)
  }
}
