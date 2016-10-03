//
//  CanvasViewControllerTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 15/09/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class CanvasViewControllerTests: XCTestCase {
  func createMouseEvent(clickCount: Int, location: NSPoint) -> NSEvent {
    return NSEvent.mouseEvent(
      with: .leftMouseDown,
      location: location,
      modifierFlags: .function,
      timestamp: 2,
      windowNumber: 0,
      context: nil,
      eventNumber: 0,
      clickCount: clickCount,
      pressure: 1.0
      )!
  }
  
  var canvasViewController: CanvasViewController!
  var canvasView: CanvasView!
  var document: TestLinkedIdeasDocument!
  
  override func setUp() {
    super.setUp()
    
    canvasViewController = CanvasViewController()
    canvasView = CanvasView()
    canvasViewController.canvasView = canvasView
    document = TestLinkedIdeasDocument()
    canvasViewController.document = document
  }
}

// MARK - CanvasViewController: Basic Behavior

extension CanvasViewControllerTests {
  func testClickedConceptsAtPointWhenIntercepsAConcept() {
    let clickedPoint = NSMakePoint(200, 300)

    let concepts = [
      Concept(stringValue: "Foo #0", point: NSMakePoint(210, 310)),
      Concept(stringValue: "Foo #1", point: NSMakePoint(210, 110)),
      Concept(stringValue: "Foo #2", point: NSMakePoint(200, 300)),
    ]
    document.concepts = concepts
    
    let clickedConcepts = canvasViewController.clickedConcepts(atPoint: clickedPoint)
    
    XCTAssertEqual(clickedConcepts?.count, 2)
    XCTAssertEqual(clickedConcepts?.contains(concepts[0]), true)
    XCTAssertEqual(clickedConcepts?.contains(concepts[2]), true)
  }
  
  func testClickedConceptsAtPointWithNoResults() {
    let clickedPoint = NSMakePoint(1200, 1300)
    
    let concepts = [
      Concept(stringValue: "Foo #0", point: NSMakePoint(210, 310)),
      Concept(stringValue: "Foo #1", point: NSMakePoint(210, 110)),
      Concept(stringValue: "Foo #2", point: NSMakePoint(200, 300)),
      ]
    document.concepts = concepts
    
    let clickedConcepts = canvasViewController.clickedConcepts(atPoint: clickedPoint)
    
    XCTAssertTrue(clickedConcepts == nil)
  }
}

// MARK - CanvasViewControllers: Mouse Tests

extension CanvasViewControllerTests {
  func testDoubleClickInCanvas() {
    let clickedPoint = NSMakePoint(200, 300)
    let mouseEvent = createMouseEvent(clickCount: 2, location: clickedPoint)
    
    canvasViewController.mouseDown(with: mouseEvent)
    
    XCTAssertEqual(canvasViewController.currentState, .newConcept(point: clickedPoint))
  }
  
  func testSingleClickInCanvasWhenConceptIsBeingCreated() {
    canvasViewController.currentState = .newConcept(point: NSPoint.zero)
    
    let clickedPoint = NSMakePoint(200, 300)
    let mouseEvent = createMouseEvent(clickCount: 1, location: clickedPoint)
    
    canvasViewController.mouseDown(with: mouseEvent)
    
    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }
  
  func testSingleClickOnCanvasWhenConceptIsSelected() {
    let concept = Concept(stringValue: "Foo bar", point: NSMakePoint(200, 300))
    document.concepts.append(concept)
    
    canvasViewController.currentState = .selectedElements(elements: [concept])
    
    let clickedPoint = NSMakePoint(10, 20)
    let clickEvent = createMouseEvent(clickCount: 1, location: clickedPoint)
    
    canvasViewController.mouseDown(with: clickEvent)
    
    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }
  
  func testSingleClickOnConcept() {
    let clickedPoint = NSMakePoint(200, 300)
    let conceptPoint = clickedPoint
    
    let concept = Concept(stringValue: "Foo bar", point: conceptPoint)
    document.concepts.append(concept)
    
    let clickEvent = createMouseEvent(clickCount: 1, location: clickedPoint)
    
    canvasViewController.mouseDown(with: clickEvent)
    
    XCTAssertEqual(canvasViewController.currentState, .selectedElements(elements: [concept]))
  }
}

// MARK - CanvasViewControllers: TextField Delegate Tests

extension CanvasViewControllerTests {
  func testPressEnterKeyWhenEditingInTheTextField() {
    let conceptPoint = NSPoint.zero
    canvasViewController.currentState = .newConcept(point: conceptPoint)
    canvasViewController.stateManager.delegate = StateManagerTestDelegate()
    
    let textField = canvasViewController.textField
    textField.stringValue = "New Concept"
    
    let _ = canvasViewController.control(
      textField,
      textView: NSTextView(),
      doCommandBy: #selector(NSResponder.insertNewline(_:))
    )
    
    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }
}

// MARK - CanvasViewControllers: StateManagerDelegate Tests

extension CanvasViewControllerTests {  
  func testShowTextFieldAt() {
    let clickedPoint = NSMakePoint(400, 300)
    canvasViewController.showTextField(atPoint: clickedPoint)
    
    XCTAssertFalse(canvasViewController.textField.isHidden)
    XCTAssert(canvasViewController.textField.isEditable)
    XCTAssertEqual(canvasViewController.textField.frame.center, clickedPoint)
  }
  
  func testDismissTextField() {
    let textFieldCenter = NSMakePoint(400, 300)
    let textField = canvasViewController.textField
    textField.frame = NSRect(center: textFieldCenter, size: NSMakeSize(60, 40))
    textField.stringValue = "Foo bar asdf"
    textField.isHidden = false
    textField.isEditable = true
    
    canvasViewController.dismissTextField()
    
    XCTAssert(canvasViewController.textField.isHidden)
    XCTAssertFalse(canvasViewController.textField.isEditable)
    XCTAssertNotEqual(canvasViewController.textField.frame.center, textFieldCenter)
    XCTAssertEqual(canvasViewController.textField.stringValue, "")
  }
  
  func testSaveConceptWithAppropriateData() {
    let document = TestLinkedIdeasDocument()
    canvasViewController.document = document
    
    let attributedString = NSAttributedString(string: "New Concept")
    let conceptCenterPoint = NSMakePoint(300, 400)
    
    let successfullSave = canvasViewController.saveConcept(
      text: attributedString,
      atPoint: conceptCenterPoint
    )
    
    XCTAssert(successfullSave)
    XCTAssertEqual(document.concepts.count, 1)
  }
  
  func testSaveConceptFailsWithBadData() {
    let document = TestLinkedIdeasDocument()
    canvasViewController.document = document
    
    let attributedString = NSAttributedString(string: "")
    let conceptCenterPoint = NSMakePoint(300, 400)
    
    let successfullSave = canvasViewController.saveConcept(
      text: attributedString,
      atPoint: conceptCenterPoint
    )
    
    XCTAssertFalse(successfullSave)
    XCTAssertEqual(document.concepts.count, 0)
  }
}
