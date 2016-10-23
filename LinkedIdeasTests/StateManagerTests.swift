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
  
  func executeTransition(block: () throws -> Void) {
    do {
      try block()
    } catch let error {
      XCTFail("transition failed with: \(error)")
    }
  }
}

// MARK: StateManager - toNewConcept Transition Tests

extension StateManagerTests {
  func testToNewConceptFromCanvasWaitingTransition() {
    executeTransition { try stateManager.toNewConcept(atPoint: NSPoint.zero) }
    
    XCTAssertEqual(stateManager.currentState, .newConcept(point: NSPoint.zero))
  }

  func testToNewConceptFromNewConceptTransition() {
    stateManager.currentState = .newConcept(point: NSMakePoint(300, 400))

    executeTransition {
      try stateManager.toNewConcept(atPoint: NSPoint.zero)
    }
    
    XCTAssertEqual(stateManager.currentState, .newConcept(point: NSPoint.zero))
  }
}

// MARK: StateManager - toCanvasWaiting Tests

extension StateManagerTests {
  func testToCanvasWaitingFromNewConcept() {
    stateManager.currentState = .newConcept(point: NSMakePoint(300, 400))
    
    executeTransition { try stateManager.toCanvasWaiting() }
    
    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
  
  func testToCanvasWaitingFromSelectedElements() {
    let testElement = TestElement.sample
    stateManager.currentState = .selectedElements(elements: [testElement])
    
    executeTransition { try stateManager.toCanvasWaiting() }
    
    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
}

// MARK: StateManager - toCanvasWaiting savingConceptWithText Tests

extension StateManagerTests {
  func testToCanvasWaitingSavingConceptFromNewConcept() {
    stateManager.currentState = .newConcept(point: NSMakePoint(300, 400))
    let text = NSAttributedString(string: "concept text")

    executeTransition {
      try stateManager.toCanvasWaiting(savingConceptWithText: text)
    }

    XCTAssertEqual(stateManager.currentState, .canvasWaiting)
  }
}


// MARK: StateManager - toSelectedElements Tests

extension StateManagerTests {
  func testToSelectedElementsFromCanvasWaiting() {
    let testElement = TestElement.sample

    executeTransition {
      try stateManager.toSelectedElements(elements: [testElement])
    }

    XCTAssertEqual(stateManager.currentState, .selectedElements(elements: [testElement]))
  }
}
