//
//  CanvasProtocolTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 10/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class CanvasViewTests: XCTestCase {
  let canvas = CanvasView(frame: NSMakeRect(20, 20, 600, 400))
  
  func testClickOnEmptyCanvas() {
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
  
  func testCreatingAConcept() {
    // when
    let pointInCanvas = NSMakePoint(100, 200)
    canvas.click(pointInCanvas)
    canvas.newConceptView?.typeText("foo bar")
    canvas.newConceptView?.pressEnterKey()
    
    // then
    XCTAssertNil(canvas.newConcept)
    XCTAssertNil(canvas.newConceptView)
    XCTAssertEqual(canvas.concepts.count, 1)
    
    let concept = canvas.concepts.first!
    let conceptView = canvas.conceptViewFor(concept)
    XCTAssertEqual(concept.point, pointInCanvas)
    XCTAssertEqual(conceptView.frame.center, pointInCanvas)
  }
  
  func testClickingOnCanvasWhenOtherConceptIsEditable() {
    // given
    let concept1 = Concept(point: NSMakePoint(1, 20))
    let concept2 = Concept(point: NSMakePoint(100, 200))
    concept1.isEditable = true
    concept2.isEditable = true
    canvas.concepts.append(concept1)
    canvas.concepts.append(concept2)
    canvas.drawConceptViews()
    
    // when
    canvas.click(NSMakePoint(20, 60))
    
    // then
    XCTAssertEqual(canvas.newConceptView!.editingString(), true)
    XCTAssertEqual(canvas.subviews.count, 3)
    XCTAssertEqual(canvas.concepts.count, 2)
    XCTAssertEqual(concept1.isEditable, false)
    XCTAssertEqual(concept2.isEditable, false)
  }
  
  func testSavingAConcept() {
    // given
    let concept = Concept(point: NSMakePoint(100, 200))
    let conceptView = ConceptView(concept: concept, canvas: canvas)
    canvas.newConcept = concept
    canvas.newConceptView = conceptView
    
    // when
    canvas.saveConcept(conceptView)
    
    // then
    XCTAssertNil(canvas.newConcept)
    XCTAssertNil(canvas.newConceptView)
    XCTAssertEqual(canvas.concepts.first!.identifier, concept.identifier)
    XCTAssertEqual(canvas.conceptViewFor(concept), conceptView)
  }
  
  func testInitializingCanvasViewFromReadingADocument() {
    // given
    let concepts = [
      Concept(stringValue: "C1", point: NSMakePoint(20, 30)),
      Concept(stringValue: "C2", point: NSMakePoint(20, 30)),
    ]
    canvas.concepts = concepts
    
    // when
    canvas.drawRect(canvas.bounds)
    
    // then
    XCTAssertEqual(canvas.conceptViews.count, 2)
  }
  
  func testSelectTargetConceptView() {
    // given
    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
    canvas.concepts = [concept2]
    let conceptView2 = ConceptView(concept: concept2, canvas: canvas)
    canvas.conceptViews = [concept2.identifier: conceptView2]
    
    // when
    canvas.mode = .Links
    let result = canvas.selectTargetConceptView(concept2.point)
    
    // then
    XCTAssertEqual(result, conceptView2)
  }
  
  func testSelectTargetConceptViewWhenNoConceptIsFound() {
    // given
    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
    canvas.concepts = [concept2]
    let conceptView2 = ConceptView(concept: concept2, canvas: canvas)
    canvas.conceptViews = [concept2.identifier: conceptView2]
    
    // when
    canvas.mode = .Links
    let result = canvas.selectTargetConceptView(NSMakePoint(0, 100))
    
    // then
    XCTAssertNil(result)
  }
  
  func testCreatingALinkBetweenTwoConcepts() {
    // given
    let concept1 = Concept(stringValue: "C1", point: NSMakePoint(20, 30))
    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
    canvas.concepts = [concept1, concept2]
    let conceptView1 = ConceptView(concept: concept1, canvas: canvas)
    let conceptView2 = ConceptView(concept: concept2, canvas: canvas)
    canvas.conceptViews = [
      concept1.identifier: conceptView1,
      concept2.identifier: conceptView2
    ]
    
    // when
    canvas.drawRect(canvas.bounds)
    canvas.mode = Mode.Links
    canvas.releaseMouseFromConceptView(conceptView1, point: concept2.point)
    
    // then
    XCTAssertEqual(canvas.links.count, 1)
    XCTAssertEqual(canvas.linkViews.count, 1)
  }
}
