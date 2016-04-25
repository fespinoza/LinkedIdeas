//
//  CanvasProtocolTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 10/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class TestDocument: LinkedIdeasDocument {
  var concepts = [Concept]()
  var links = [Link]()
  
  var observer: DocumentObserver?
  
  func saveConcept(concept: Concept) {
    concepts.append(concept)
    observer?.conceptAdded(concept)
  }
  
  func removeConcept(concept: Concept) {
    concepts.removeAtIndex(concepts.indexOf(concept)!)
    observer?.conceptRemoved(concept)
  }
  
  func saveLink(link: Link) {
    links.append(link)
    observer?.linkAdded(link)
  }
  
  func removeLink(link: Link) {
    links.removeAtIndex(links.indexOf(link)!)
    observer?.linkRemoved(link)
  }
}

class CanvasViewTests: XCTestCase {
  let canvas = CanvasView(frame: NSMakeRect(20, 20, 600, 400))
  let testDocument = TestDocument()
  
  override func setUp() {
    canvas.document = testDocument
  }
  
  // MARK: - Initialization
  
  func testInitializingCanvasViewFromReadingADocument() {
    // given
    let concepts = [
      Concept(stringValue: "C1", point: NSMakePoint(20, 30)),
      Concept(stringValue: "C2", point: NSMakePoint(20, 30)),
      ]
    let links = [
      Link(origin: concepts[0], target: concepts[1])
    ]
    testDocument.concepts = concepts
    testDocument.links = links
    
    // when
    canvas.drawRect(canvas.bounds)
    
    // then
    XCTAssertEqual(canvas.conceptViews.count, 2)
    XCTAssertEqual(canvas.linkViews.count, 1)
    XCTAssertEqual(canvas.subviews.count, 3)
  }
  
  // MARK: - Concept Mode
  
  func testClickOnEmptyCanvas() {
    // given
    canvas.mode = .Concepts
    
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
    // given
    canvas.mode = .Concepts
    
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
  
  func testDoubleClickingOnCanvasWhenOtherConceptIsEditable() {
    // given
    let concept1 = Concept(point: NSMakePoint(1, 20))
    let concept2 = Concept(point: NSMakePoint(100, 200))
    concept1.isEditable = true
    concept2.isEditable = true
    testDocument.concepts.append(concept1)
    testDocument.concepts.append(concept2)
    canvas.mode = .Concepts
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
    canvas.mode = .Concepts
    canvas.newConcept = concept
    canvas.newConceptView = conceptView
    
    // when
    canvas.saveConcept(conceptView)
    
    // then
    XCTAssertNil(canvas.newConcept)
    XCTAssertNil(canvas.newConceptView)
    XCTAssertEqual(canvas.concepts.first!.identifier, concept.identifier)
    XCTAssertEqual(canvas.conceptViews.count, 1)
  }
  
  func testRemovingAConcept() {
    // given
    let concept = Concept(point: NSMakePoint(100, 200))
    testDocument.concepts = [concept]
    canvas.drawConceptViews()
    
    XCTAssertEqual(canvas.conceptViews.count, 1)
    XCTAssertEqual(canvas.subviews.count, 1)
    
    // when
    canvas.conceptRemoved(concept)
    
    // then
    XCTAssertEqual(canvas.conceptViews.count, 0)
    XCTAssertEqual(canvas.subviews.count, 0)
  }
  
  // MARK: - Link Mode
  
  func testSelectTargetConceptView() {
    // given
    let concept1 = Concept(stringValue: "C1", point: NSMakePoint(120, 130))
    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
    testDocument.concepts = [concept1, concept2]
    canvas.drawConceptViews()
    let conceptView2 = canvas.conceptViewFor(concept2)
    
    // when
    canvas.mode = .Links
    let result = canvas.selectTargetConceptView(concept2.point, fromConcept: concept1)
    
    // then
    XCTAssertEqual(result, conceptView2)
  }
  
  func testSelectTargetConceptViewInSameConcept() {
    // given
    let concept1 = Concept(stringValue: "C1", point: NSMakePoint(120, 130))
    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
    testDocument.concepts = [concept1, concept2]
    canvas.drawConceptViews()
    
    // when
    canvas.mode = .Links
    let result = canvas.selectTargetConceptView(concept1.point, fromConcept: concept1)
    
    // then
    XCTAssertNil(result)
  }
  
  func testSelectTargetConceptViewWhenNoConceptIsFound() {
    // given
    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
    testDocument.concepts = [concept2]
    let conceptView2 = ConceptView(concept: concept2, canvas: canvas)
    canvas.conceptViews = [concept2.identifier: conceptView2]
    
    // when
    canvas.mode = .Links
    let result = canvas.selectTargetConceptView(NSMakePoint(0, 100), fromConcept: concept2)
    
    // then
    XCTAssertNil(result)
  }
  
  func testCreatingALinkBetweenTwoConcepts() {
    // given
    let concept1 = Concept(stringValue: "C1", point: NSMakePoint(20, 30))
    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
    testDocument.concepts = [concept1, concept2]
    let conceptView1 = ConceptView(concept: concept1, canvas: canvas)
    let conceptView2 = ConceptView(concept: concept2, canvas: canvas)
    canvas.conceptViews = [
      concept1.identifier: conceptView1,
      concept2.identifier: conceptView2
    ]
    
    // when
    canvas.drawRect(canvas.bounds)
    canvas.mode = .Links
    canvas.releaseMouseFromConceptView(conceptView1, point: concept2.point)
    
    // then
    XCTAssertEqual(canvas.links.count, 1)
    XCTAssertEqual(canvas.linkViews.count, 1)
  }
  
  func testClickOnEmptyCanvasOnLinkMode() {
    // given
    canvas.mode = .Links
    
    // when
    canvas.click(NSMakePoint(20, 60))
    
    // then
    XCTAssertNil(canvas.newConcept)
    XCTAssertNil(canvas.newConceptView)
  }
  
  func testClickingOnCanvasDeselectsConceptsAndLinks() {
    // given
    let concepts = [
      Concept(stringValue: "C1", point: NSMakePoint(20, 30)),
      Concept(stringValue: "C2", point: NSMakePoint(20, 30)),
      ]
    let links = [
      Link(origin: concepts[0], target: concepts[1])
    ]
    testDocument.concepts = concepts
    testDocument.links = links
    links.first!.isSelected = true
    concepts.first!.isSelected = true
    
    // when
    canvas.drawRect(canvas.bounds)
    canvas.click(NSMakePoint(20, 50))
    
    // then
    XCTAssertEqual(links.first!.isSelected, false)
    XCTAssertEqual(concepts.first!.isSelected, false)
  }
}
