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
  let testElement = TestElement.sample

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
    stateManager.currentState = .selectedElement(element: testElement)

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


// MARK: StateManager - toSelectedElement Tests

extension StateManagerTests {
  func testToSelectedElementFromCanvasWaiting() {
    executeTransition {
      try stateManager.toSelectedElement(element: testElement)
    }

    XCTAssertEqual(
      stateManager.currentState,
      .selectedElement(element: testElement)
    )
  }

  func testToSelectedElementFromEditingElement() {
    stateManager.currentState = .editingElement(element: testElement)

    executeTransition {
      try stateManager.toSelectedElement(element: testElement)
    }

    XCTAssertEqual(stateManager.currentState, .selectedElement(element: testElement))
  }
}

// MARK: StateManager - toSelectedElementSavingChanges

extension StateManagerTests {
  func testToSelectedElementSavingChangesFromEditingElement() {
    stateManager.currentState = .editingElement(element: testElement)

    executeTransition {
      try stateManager.toSelectedElementSavingChanges(element: testElement)
    }

    XCTAssertEqual(stateManager.currentState, .selectedElement(element: testElement))
  }
}

// MARK: StateManager - toEditingElement

extension StateManagerTests {
  func testToEditingElementFromSelectedElement() {
    stateManager.currentState = .selectedElement(element: testElement)

    executeTransition {
      try stateManager.toEditingElement(element: testElement)
    }

    XCTAssertEqual(
      stateManager.currentState,
      .editingElement(element: testElement)
    )
  }
}

// MARK: StateManager - toNewLink Transition Tests

extension StateManagerTests {
  func testToNewConceptFromSelectedElement() {
    let conceptA = Concept(stringValue: "A", point: NSMakePoint(400, 300))
    let conceptB = Concept(stringValue: "B", point: NSMakePoint(200, 100))
    stateManager.currentState = .selectedElement(element: conceptA)
    
    executeTransition { try stateManager.toNewLink(fromConcept: conceptA, toConcept: conceptB) }
    
    XCTAssertEqual(stateManager.currentState, .newLink(fromConcept: conceptA, toConcept: conceptB))
  }
}

