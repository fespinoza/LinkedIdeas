//
//  StateManagerTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 24/09/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class StateManagerTests: XCTestCase {
  var stateManager: StateManager!
  var testDelegate: StateManagerTestDelegate!
  
  override func setUp() {
    super.setUp()
    
    stateManager = StateManager(initialState: .canvasWaiting)
    testDelegate = StateManagerTestDelegate()
    stateManager.delegate = testDelegate
  }
}

// MARK: StateManager - ToNewConceptTransition Tests

extension StateManagerTests {
  func testFromCanvasWaitingToNewConceptTransition() {
    let transitionSuccessful = stateManager.toNewConcept(atPoint: NSPoint.zero)
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], nil)
    XCTAssertEqual(testDelegate.methodCalls["showTextField(atPoint:)"], 1)
    XCTAssertEqual(stateManager.currentState, .newConcept(point: NSPoint.zero))
  }
  
  func testFromNewConceptToNewConceptTransition() {
    stateManager.currentState = .newConcept(point: NSMakePoint(300, 400))
    
    let transitionSuccessful = stateManager.toNewConcept(atPoint: NSPoint.zero)
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], 1)
    XCTAssertEqual(testDelegate.methodCalls["showTextField(atPoint:)"], 1)
    XCTAssertEqual(stateManager.currentState, .newConcept(point: NSPoint.zero))
  }
}

// MARK: StateManager - SaveConceptTransition Tests

extension StateManagerTests {
  func testFromCanvasWaitingToSaveConceptTransition() {
    let transitionSuccessful = stateManager.saveNewConcept(text: NSAttributedString(string: "concept text"))
    
    XCTAssertFalse(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["saveConcept(text:atPoint:)"], nil)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], nil)
    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
  
  func testFromNewConceptToSaveConceptTransition() {
    let newConceptPoint = NSMakePoint(300, 400)
    stateManager.currentState = .newConcept(point: newConceptPoint)
    
    let transitionSuccessful = stateManager.saveNewConcept(text: NSAttributedString(string: "concept text"))
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["saveConcept(text:atPoint:)"], 1)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], 1)
    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
}

// MARK: StateManager - CancelNewConceptTransition Tests

extension StateManagerTests {
  func testFromNewConceptToCancelConceptTransition() {
    let newConceptPoint = NSMakePoint(300, 400)
    stateManager.currentState = .newConcept(point: newConceptPoint)
    
    let transitionSuccessful = stateManager.cancelNewConcept()
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["saveConcept(text:atPoint:)"], nil)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], 1)
    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
}

// MARK: StateManager - selectElements Tests

extension StateManagerTests {
  func testFromCanvasWaitingToSelectedElements() {
    let testElement = TestElement.sample
    
    let transitionSuccessful = stateManager.select(elements: [testElement])
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(stateManager.currentState, .selectedElements(elements: [testElement]))
  }
}

// MARK: StateManager - deselectElements Tests

extension StateManagerTests {
  func testFromSelectedElementsToCanvasWaiting() {
    let testElement = TestElement.sample
    stateManager.currentState = .selectedElements(elements: [testElement])
    
    let transitionSuccessful = stateManager.deselectElements()
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
}

