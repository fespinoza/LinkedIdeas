//
//  CanvasViewControllerTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 15/09/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class TestLinkedIdeasDocument: LinkedIdeasDocument {
  var concepts = [Concept]()
  var links = [Link]()
  var observer: DocumentObserver? = nil
  
  func save(concept: Concept) {
    concepts.append(concept)
  }
  func remove(concept: Concept) {}
  
  func save(link: Link) {}
  func remove(link: Link) {}
  
  func move(concept: Concept, toPoint: NSPoint) {}
}

// MARK - CanvasViewControllers: Mouse Tests

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

// MARK - CanvasViewControllers: TextField Delegate Tests

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

// MARK - CanvasViewControllers: StateManagerDelegate Tests

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
