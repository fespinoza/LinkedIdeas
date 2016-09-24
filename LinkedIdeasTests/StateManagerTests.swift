//
//  StateManagerTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 24/09/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

// StateManager
// transition -> can go from "state A" to "state B"?
//                 -> if so, go
//                 -> else, don't
//

class StateManagerTestDelegate {
  var methodCalls = [String: Int]()
  
  func registerCall(methodName: String) {
    if let currentCallsNumber = methodCalls[methodName] {
      methodCalls[methodName] = currentCallsNumber + 1
    } else {
      methodCalls[methodName] = 1
    }
  }
}

extension StateManagerTestDelegate: StateManagerDelegate {
  func unselectAllElements() {
    registerCall(methodName: #function)
  }
  
  // concepts
  func cancelConceptCreation() {
    registerCall(methodName: #function)
  }
  
  func saveConcept(text: NSAttributedString, atPoint: NSPoint) {
    registerCall(methodName: #function)
  }
  
  // text field
  func showTextField(atPoint: NSPoint) {
    registerCall(methodName: #function)
  }
  
  func dismissTextField() {
    registerCall(methodName: #function)
  }
}

// MARK: StateManager - ToNewConceptTransition Tests

class StateManager_ToNewConceptTransitionTests: XCTestCase {
  func testFromCanvasWaitingTransition() {
    var stateManager = StateManager(initialState: .canvasWaiting)
    let testDelegate = StateManagerTestDelegate()
    stateManager.delegate = testDelegate
    
    let transitionSuccessful = stateManager.toNewConcept(atPoint: NSPoint.zero)
    
    XCTAssert(transitionSuccessful)
    XCTAssertEqual(testDelegate.methodCalls["dismissTextField()"], nil)
    XCTAssertEqual(testDelegate.methodCalls["showTextField(atPoint:)"], 1)
    XCTAssertEqual(stateManager.currentState, .newConcept(point: NSPoint.zero))
  }
  
  func testFromNewConceptTransition() {
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

class StateManager_SaveConceptTransitionTests: XCTestCase {
  
}

// MARK: StateManager - CancelNewConceptTransition Tests

class StateManager_CancelNewConceptTransitionTests: XCTestCase {
  
}
