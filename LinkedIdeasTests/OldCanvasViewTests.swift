////
////  CanvasProtocolTests.swift
////  LinkedIdeas
////
////  Created by Felipe Espinoza Castillo on 10/03/16.
////  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
////
//
//import XCTest
//@testable import LinkedIdeas
//
//class TestDocument: LinkedIdeasDocument {
//  var concepts = [Concept]()
//  var links = [Link]()
//  
//  var observer: DocumentObserver?
//  
//  func save(concept: Concept) {
//    concepts.append(concept)
//    observer?.documentChanged(withElement: concept as Element)
//  }
//  
//  func remove(concept: Concept) {
//    concepts.remove(at: concepts.index(of: concept)!)
//    observer?.documentChanged(withElement: concept as Element)
//  }
//  
//  func save(link: Link) {
//    links.append(link)
//    observer?.documentChanged(withElement: link as Element)
//  }
//  
//  func remove(link: Link) {
//    links.remove(at: links.index(of: link)!)
//    observer?.documentChanged(withElement: link as Element)
//  }
//  
//  func move(concept: Concept, toPoint: NSPoint) {
//    concept.point = toPoint
//  }
//}
//
//class OldCanvasViewTests: XCTestCase {
//  let canvas = OldCanvasView(frame: NSMakeRect(20, 20, 600, 400))
//  let testDocument = TestDocument()
//  
//  override func setUp() {
//    canvas.document = testDocument
//  }
//  
//  // MARK: - Initialization
//  
//  func testInitializingOldCanvasViewFromReadingADocument() {
//    // given
//    let concepts = [
//      Concept(stringValue: "C1", point: NSMakePoint(20, 30)),
//      Concept(stringValue: "C2", point: NSMakePoint(20, 30)),
//      ]
//    let links = [
//      Link(origin: concepts[0], target: concepts[1])
//    ]
//    testDocument.concepts = concepts
//    testDocument.links = links
//    
//    // when
//    canvas.draw(canvas.bounds)
//    
//    // then
//    XCTAssertEqual(canvas.conceptViews.count, 2)
//    XCTAssertEqual(canvas.linkViews.count, 1)
//    XCTAssertEqual(canvas.subviews.count, 3)
//  }
//  
//  // MARK: - Concept Mode
//  
//  func testClickOnEmptyCanvas() {
//    // given
//    canvas.mode = .Concepts
//    
//    // when
//    let clickedPoint = NSMakePoint(20, 60)
//    canvas.click(clickedPoint)
//    
//    // then
//    let newConcept: Concept? = canvas.newConcept
//    let newConceptView: ConceptView? = canvas.newConceptView
//    
//    XCTAssertNotNil(newConcept)
//    XCTAssertEqual(newConcept!.point, clickedPoint)
//    XCTAssertEqual(newConcept!.isEditable, true)
//    XCTAssertEqual(newConceptView!.editingString(), true)
//    XCTAssertEqual(newConceptView!.textFieldSize, NSMakeSize(60, 20))
//  }
//  
//  func testCreatingAConcept() {
//    // given
//    canvas.mode = .Concepts
//    
//    // when
//    let pointInCanvas = NSMakePoint(100, 200)
//    canvas.click(pointInCanvas)
//    canvas.newConceptView?.typeText("foo bar")
//    canvas.newConceptView?.pressEnterKey()
//    
//    // then
//    XCTAssertNil(canvas.newConcept)
//    XCTAssertNil(canvas.newConceptView)
//    XCTAssertEqual(canvas.concepts.count, 1)
//    
//    let concept = canvas.concepts.first!
//    let conceptView = canvas.conceptViewFor(concept)
//    XCTAssertEqual(concept.point, pointInCanvas)
//    XCTAssertEqual(conceptView.frame.center, pointInCanvas)
//  }
//  
//  func testDoubleClickingOnCanvasWhenOtherConceptIsEditable() {
//    // given
//    let concept1 = Concept(point: NSMakePoint(1, 20))
//    let concept2 = Concept(point: NSMakePoint(100, 200))
//    concept1.isEditable = true
//    concept2.isEditable = true
//    testDocument.concepts.append(concept1)
//    testDocument.concepts.append(concept2)
//    canvas.mode = .Concepts
//    canvas.drawConceptViews()
//    
//    // when
//    canvas.click(NSMakePoint(20, 60))
//    
//    // then
//    XCTAssertEqual(canvas.newConceptView!.editingString(), true)
//    XCTAssertEqual(canvas.subviews.count, 3)
//    XCTAssertEqual(canvas.concepts.count, 2)
//    XCTAssertEqual(concept1.isEditable, false)
//    XCTAssertEqual(concept2.isEditable, false)
//  }
//  
//  func testSavingAConcept() {
//    // given
//    let concept = Concept(point: NSMakePoint(100, 200))
//    let conceptView = ConceptView(concept: concept, canvas: canvas)
//    canvas.mode = .Concepts
//    canvas.newConcept = concept
//    canvas.newConceptView = conceptView
//    
//    // when
//    canvas.saveConcept(conceptView)
//    
//    // then
//    XCTAssertNil(canvas.newConcept)
//    XCTAssertNil(canvas.newConceptView)
//    XCTAssertEqual(canvas.concepts.first!.identifier, concept.identifier)
//    XCTAssertEqual(canvas.conceptViews.count, 1)
//  }
//  
//  func testRemovingAConcept() {
//    // given
//    let concept = Concept(point: NSMakePoint(100, 200))
//    testDocument.concepts = [concept]
//    canvas.drawConceptViews()
//    
//    XCTAssertEqual(canvas.conceptViews.count, 1)
//    XCTAssertEqual(canvas.subviews.count, 1)
//    
//    // when
//    canvas.conceptRemoved(concept)
//    
//    // then
//    XCTAssertEqual(canvas.conceptViews.count, 0)
//    XCTAssertEqual(canvas.subviews.count, 0)
//  }
//  
//  // MARK: - Link Mode
//  
//  func testSelectTargetConceptView() {
//    // given
//    let concept1 = Concept(stringValue: "C1", point: NSMakePoint(120, 130))
//    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
//    testDocument.concepts = [concept1, concept2]
//    canvas.drawConceptViews()
//    let conceptView2 = canvas.conceptViewFor(concept2)
//    
//    // when
//    canvas.mode = .Links
//    let result = canvas.selectTargetConceptView(concept2.point, fromConcept: concept1)
//    
//    // then
//    XCTAssertEqual(result, conceptView2)
//  }
//  
//  func testSelectTargetConceptViewInSameConcept() {
//    // given
//    let concept1 = Concept(stringValue: "C1", point: NSMakePoint(120, 130))
//    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
//    testDocument.concepts = [concept1, concept2]
//    canvas.drawConceptViews()
//    
//    // when
//    canvas.mode = .Links
//    let result = canvas.selectTargetConceptView(concept1.point, fromConcept: concept1)
//    
//    // then
//    XCTAssertNil(result)
//  }
//  
//  func testSelectTargetConceptViewWhenNoConceptIsFound() {
//    // given
//    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
//    testDocument.concepts = [concept2]
//    let conceptView2 = ConceptView(concept: concept2, canvas: canvas)
//    canvas.conceptViews = [concept2.identifier: conceptView2]
//    
//    // when
//    canvas.mode = .Links
//    let result = canvas.selectTargetConceptView(NSMakePoint(0, 100), fromConcept: concept2)
//    
//    // then
//    XCTAssertNil(result)
//  }
//  
//  func testCreatingALinkBetweenTwoConcepts() {
//    // given
//    let concept1 = Concept(stringValue: "C1", point: NSMakePoint(20, 30))
//    let concept2 = Concept(stringValue: "C2", point: NSMakePoint(220, 230))
//    testDocument.concepts = [concept1, concept2]
//    let conceptView1 = ConceptView(concept: concept1, canvas: canvas)
//    let conceptView2 = ConceptView(concept: concept2, canvas: canvas)
//    canvas.conceptViews = [
//      concept1.identifier: conceptView1,
//      concept2.identifier: conceptView2
//    ]
//    
//    // when
//    canvas.draw(canvas.bounds)
//    canvas.mode = .Links
//    canvas.dragEndCallback(conceptView1, dragEvent: DragEvent(fromPoint: concept1.point, toPoint: concept2.point))
//    
//    // then
//    XCTAssertEqual(canvas.links.count, 1)
//    XCTAssertEqual(canvas.linkViews.count, 1)
//  }
//  
//  func testClickOnEmptyCanvasOnLinkMode() {
//    // given
//    canvas.mode = .Links
//    
//    // when
//    canvas.click(NSMakePoint(20, 60))
//    
//    // then
//    XCTAssertNil(canvas.newConcept)
//    XCTAssertNil(canvas.newConceptView)
//  }
//  
//  func testClickingOnCanvasDeselectsConceptsAndLinks() {
//    // given
//    let concepts = [
//      Concept(stringValue: "C1", point: NSMakePoint(20, 30)),
//      Concept(stringValue: "C2", point: NSMakePoint(20, 30)),
//      ]
//    let links = [
//      Link(origin: concepts[0], target: concepts[1])
//    ]
//    testDocument.concepts = concepts
//    testDocument.links = links
//    links.first!.isSelected = true
//    concepts.first!.isSelected = true
//    
//    // when
//    canvas.draw(canvas.bounds)
//    canvas.click(NSMakePoint(20, 50))
//    
//    // then
//    XCTAssertEqual(links.first!.isSelected, false)
//    XCTAssertEqual(concepts.first!.isSelected, false)
//  }
//  
//  func testMultipleSelectionOfConcepts() {
//    let concepts = [
//      Concept(stringValue: "C1", point: NSMakePoint(20, 30)),
//      Concept(stringValue: "C2", point: NSMakePoint(20, 30)),
//    ]
//    testDocument.concepts = concepts
//    concepts.first!.isSelected = true
//    canvas.drawConceptViews()
//    let conceptView2 = canvas.conceptViewFor(concepts[1])
//    canvas.mode = .Select
//    
//    // when
//    conceptView2.shiftClick(NSMakePoint(50, 60))
//    
//    // then
//    XCTAssertEqual(concepts[0].isSelected, true)
//    XCTAssertEqual(concepts[1].isSelected, true)
//  }
//  
//  func testDeselectAConceptOnMultipleSelect() {
//    let concepts = [
//      Concept(stringValue: "C1", point: NSMakePoint(20, 30)),
//      Concept(stringValue: "C2", point: NSMakePoint(20, 30)),
//    ]
//    testDocument.concepts = concepts
//    concepts[0].isSelected = true
//    concepts[1].isSelected = true
//    canvas.mode = .Select
//    canvas.drawConceptViews()
//    let conceptView2 = canvas.conceptViewFor(concepts[1])
//    
//    XCTAssertEqual(concepts[1].isSelected, true)
//    
//    // when
//    conceptView2.shiftClick(NSMakePoint(50, 60))
//    
//    // then
//    XCTAssertEqual(concepts[0].isSelected, true)
//    XCTAssertEqual(concepts[1].isSelected, false)
//  }
//  
//  func testDraggingMultipleConcepts() {
//    // given
//    let concepts = [
//      Concept(stringValue: "foo", point: NSMakePoint(200, 300)),
//      Concept(stringValue: "bar", point: NSMakePoint(100, 450)),
//      Concept(stringValue: "baz", point: NSMakePoint(300, 200))
//    ]
//    testDocument.concepts = concepts
//    concepts[0].isSelected = true
//    concepts[1].isSelected = true
//    canvas.mode = .Select
//    canvas.drawConceptViews()
//    let conceptView2 = canvas.conceptViewFor(concepts[1])
//    
//    // when
//    let initialPoints = concepts.map { $0.point }
//    let newPoint2 = NSMakePoint(120, 400) // x+20,y-50
//    let newPoint3 = NSMakePoint(150, 420) // +30, +20
//    canvas.dragToCallback(conceptView2, dragEvent: DragEvent(fromPoint: initialPoints[1], toPoint: newPoint2))
//    canvas.dragToCallback(conceptView2, dragEvent: DragEvent(fromPoint: newPoint2, toPoint: newPoint3))
//    
//    // then
//    XCTAssertEqual(concepts[0].point, initialPoints[0].translate(deltaX: 50, deltaY: -30))
//    XCTAssertEqual(concepts[1].point, initialPoints[1])
//    XCTAssertEqual(concepts[2].point, initialPoints[2])
//  }
//}
