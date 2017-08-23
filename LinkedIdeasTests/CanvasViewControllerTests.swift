//
//  CanvasViewControllerTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 15/09/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

extension CanvasViewController {
  func fullClick(event: NSEvent) {
    self.mouseDown(with: event)
    self.mouseDragged(with: event)
    self.mouseUp(with: event)
  }
}

class CanvasViewControllerTests: XCTestCase {
  // this is used because of flipping the CanvasView for working with iOS
  func invertY(_ point: NSPoint) -> NSPoint {
    return NSPoint(x: point.x, y: -point.y)
  }

  func createMouseEvent(clickCount: Int, location: NSPoint, shift: Bool = false) -> NSEvent {
    var flags: NSEvent.ModifierFlags = NSEvent.ModifierFlags.function

    if shift {
      flags = NSEvent.ModifierFlags.shift
    }

    return NSEvent.mouseEvent(
      with: .leftMouseDown,
      location: invertY(location),
      modifierFlags: flags,
      timestamp: 2,
      windowNumber: 0,
      context: nil,
      eventNumber: 0,
      clickCount: clickCount,
      pressure: 1.0
    )!
  }

  func createKeyboardEvent(keyCode: UInt16, shift: Bool = false) -> NSEvent {
    var flags: NSEvent.ModifierFlags = NSEvent.ModifierFlags.function

    if shift {
      flags = NSEvent.ModifierFlags.shift
    }

    return NSEvent.keyEvent(
      with: .keyDown,
      location: NSPoint.zero,
      modifierFlags: flags,
      timestamp: 2,
      windowNumber: 0,
      context: nil,
      characters: "",
      charactersIgnoringModifiers: "",
      isARepeat: false,
      keyCode: keyCode
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

// MARK: - CanvasViewController: Basic Behavior

extension CanvasViewControllerTests {
  func testClickedConceptsAtPointWhenIntercepsAConcept() {
    let clickedPoint = NSPoint(x: 205, y: 305)

    let concepts = [
      Concept(stringValue: "Foo #0", centerPoint: NSPoint(x: 210, y: 310)),
      Concept(stringValue: "Foo #1", centerPoint: NSPoint(x: 210, y: 110)),
      Concept(stringValue: "Foo #2", centerPoint: NSPoint(x: 200, y: 300))
    ]
    document.concepts = concepts

    let clickedConcepts = canvasViewController.clickedConcepts(atPoint: clickedPoint)

    XCTAssertEqual(clickedConcepts?.count, 2)
    XCTAssertEqual(clickedConcepts?.contains(concepts[0]), true)
    XCTAssertEqual(clickedConcepts?.contains(concepts[2]), true)
  }

  func testClickedConceptsAtPointWithNoResults() {
    let clickedPoint = NSPoint(x: 1200, y: 1300)

    let concepts = [
      Concept(stringValue: "Foo #0", centerPoint: NSPoint(x: 210, y: 310)),
      Concept(stringValue: "Foo #1", centerPoint: NSPoint(x: 210, y: 110)),
      Concept(stringValue: "Foo #2", centerPoint: NSPoint(x: 200, y: 300))
      ]
    document.concepts = concepts

    let clickedConcepts = canvasViewController.clickedConcepts(atPoint: clickedPoint)

    XCTAssertTrue(clickedConcepts == nil)
  }
}

// MARK: - CanvasViewControllers: TextField Delegate Tests

//extension CanvasViewControllerTests {
//  func testPressEnterKeyWhenEditingInTheTextField() {
//    let conceptPoint = NSPoint.zero
//    canvasViewController.currentState = .newConcept(point: conceptPoint)
//    canvasViewController.stateManager.delegate = StateManagerTestDelegate()
//
//    let textField = canvasViewController.textField
//    textField.stringValue = "New Concept"
//
//    _ = canvasViewController.control(
//      textField,
//      textView: NSTextView(),
//      doCommandBy: #selector(NSResponder.insertNewline(_:))
//    )
//
//    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
//  }
//}

// MARK: - CanvasViewControllers: Transition Acction Tests

extension CanvasViewControllerTests {
//  func testShowTextFieldAt() {
//    let clickedPoint = NSPoint(x: 400, y: 300)
//    canvasViewController.showTextView(atPoint: clickedPoint)
//
//    XCTAssertFalse(canvasViewController.textField.isHidden)
//    XCTAssert(canvasViewController.textField.isEditable)
//    XCTAssertEqual(canvasViewController.textField.frame.center, clickedPoint)
//  }
//
//  func testDismissTextField() {
//    let textFieldCenter = NSPoint(x: 400, y: 300)
//    let textField = canvasViewController.textField
//    textField.frame = NSRect(center: textFieldCenter, size: NSSize(width: 60, height: 40))
//    textField.stringValue = "Foo bar asdf"
//    textField.isHidden = false
//    textField.isEditable = true
//
//    canvasViewController.dismissTextView()
//
//    XCTAssert(canvasViewController.textField.isHidden)
//    XCTAssertFalse(canvasViewController.textField.isEditable)
//    XCTAssertNotEqual(canvasViewController.textField.frame.center, textFieldCenter)
//    XCTAssertEqual(canvasViewController.textField.stringValue, "")
//  }

  func testSaveConceptWithAppropriateData() {
    let document = TestLinkedIdeasDocument()
    canvasViewController.document = document

    let attributedString = NSAttributedString(string: "New Concept")
    let conceptCenterPoint = NSPoint(x: 300, y: 400)

    let concept = canvasViewController.saveConcept(
      text: attributedString,
      atPoint: conceptCenterPoint
    )

    XCTAssert(concept != nil)
    XCTAssertEqual(document.concepts.count, 1)
  }

  func testSaveConceptFailsWithBadData() {
    let document = TestLinkedIdeasDocument()
    canvasViewController.document = document

    let attributedString = NSAttributedString(string: "")
    let conceptCenterPoint = NSPoint(x: 300, y: 400)

    let concept = canvasViewController.saveConcept(
      text: attributedString,
      atPoint: conceptCenterPoint
    )

    XCTAssertFalse(concept != nil)
    XCTAssertEqual(document.concepts.count, 0)
  }
}
