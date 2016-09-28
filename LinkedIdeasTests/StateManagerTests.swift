//
//  StateManagerTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 24/09/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class StateManagerTests: XCTestCase {}

// MARK: StateManager - ToNewConceptTransition Tests

extension StateManagerTests {
  func testFromCanvasWaitingToNewConceptTransition() {
    var stateManager = StateManager(initialState: .canvasWaiting)
    let testDelegate = StateManagerTestDelegate()
    stateManager.delegate = testDelegate
    
    let transitionSuccessful = stateManager.toNewConcept(atPoint: NSPoint.zero)
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], nil)
    XCTAssertEqual(testDelegate.methodCalls["showTextField(atPoint:)"], 1)
    XCTAssertEqual(stateManager.currentState, .newConcept(point: NSPoint.zero))
  }
  
  func testFromNewConceptToNewConceptTransition() {
    var stateManager = StateManager(initialState: .newConcept(point: NSMakePoint(300, 400)))
    let testDelegate = StateManagerTestDelegate()
    stateManager.delegate = testDelegate
    
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
    var stateManager = StateManager(initialState: .canvasWaiting)
    let testDelegate = StateManagerTestDelegate()
    stateManager.delegate = testDelegate
    
    let transitionSuccessful = stateManager.saveNewConcept(text: NSAttributedString(string: "concept text"))
    
    XCTAssertFalse(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["saveConcept(text:atPoint:)"], nil)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], nil)
    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
  
  func testFromNewConceptToSaveConceptTransition() {
    let newConceptPoint = NSMakePoint(300, 400)
    var stateManager = StateManager(initialState: .newConcept(point: newConceptPoint))
    let testDelegate = StateManagerTestDelegate()
    stateManager.delegate = testDelegate
    
    let transitionSuccessful = stateManager.saveNewConcept(text: NSAttributedString(string: "concept text"))
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["saveConcept(text:atPoint:)"], 1)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], 1)
    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
}

// MARK: StateManager - CancelNewConceptTransition Tests

extension StateManagerTests {
  
}
