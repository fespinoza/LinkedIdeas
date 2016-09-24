//
//  CanvasViewControllerTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 15/09/2016.
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

// MARK - CanvasViewControllers: Integration tests

class CanvasViewController_MouseEventTests: XCTestCase {
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
  
  func testDoubleClick() {
    let clickedPoint = NSMakePoint(200, 300)
    let mouseEvent = createMouseEvent(clickCount: 2, location: clickedPoint)
    let canvasViewController = CanvasViewController()
    
    canvasViewController.mouseDown(with: mouseEvent)
    
    XCTAssertEqual(canvasViewController.currentState, .newConcept(point: clickedPoint))
  }
  
}

class CanvasViewController_TextFieldDelegateEvents: XCTestCase {
  func testPressEnterKeyWhenEditingInTheTextField() {
    let conceptPoint = NSPoint.zero
    let canvasViewController = CanvasViewController()
    canvasViewController.currentState = .newConcept(point: conceptPoint)
    
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

class CanvasViewController_StateManagerDelegateTests: XCTestCase {
  
  func testShowTextFieldAt() {
    let canvasViewController = CanvasViewController()
    
    let clickedPoint = NSMakePoint(400, 300)
    canvasViewController.showTextField(atPoint: clickedPoint)
    
    XCTAssertFalse(canvasViewController.textField.isHidden)
    XCTAssert(canvasViewController.textField.isEditable)
    XCTAssertEqual(canvasViewController.textField.frame.center, clickedPoint)
  }
  
  func testDismissTextField() {
    let canvasViewController = CanvasViewController()
    
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
}
