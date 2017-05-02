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
    let clickedPoint = NSPoint(x: 200, y: 300)

    let concepts = [
      Concept(stringValue: "Foo #0", point: NSPoint(x: 210, y: 310)),
      Concept(stringValue: "Foo #1", point: NSPoint(x: 210, y: 110)),
      Concept(stringValue: "Foo #2", point: NSPoint(x: 200, y: 300))
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
      Concept(stringValue: "Foo #0", point: NSPoint(x: 210, y: 310)),
      Concept(stringValue: "Foo #1", point: NSPoint(x: 210, y: 110)),
      Concept(stringValue: "Foo #2", point: NSPoint(x: 200, y: 300))
      ]
    document.concepts = concepts

    let clickedConcepts = canvasViewController.clickedConcepts(atPoint: clickedPoint)

    XCTAssertTrue(clickedConcepts == nil)
  }
}

// MARK - CanvasViewControllers: Mouse Tests

extension CanvasViewControllerTests {
  func testDoubleClickInCanvas() {
    let clickedPoint = NSPoint(x: 200, y: 300)
    let mouseEvent = createMouseEvent(clickCount: 2, location: clickedPoint)

    canvasViewController.mouseDown(with: mouseEvent)

    XCTAssertEqual(canvasViewController.currentState, .newConcept(point: clickedPoint))
  }

  func testSingleClickInCanvasWhenConceptIsBeingCreated() {
    canvasViewController.currentState = .newConcept(point: NSPoint.zero)

    let clickedPoint = NSPoint(x: 200, y: 300)
    let mouseEvent = createMouseEvent(clickCount: 1, location: clickedPoint)

    canvasViewController.mouseDown(with: mouseEvent)

    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }

  func testSingleClickOnCanvasWhenConceptIsSelected() {
    let concept = Concept(stringValue: "Foo bar", point: NSPoint(x: 200, y: 300))
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: concept)

    let clickedPoint = NSPoint(x: 10, y: 20)
    let clickEvent = createMouseEvent(clickCount: 1, location: clickedPoint)

    canvasViewController.mouseDown(with: clickEvent)

    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }

  func testSingleClickOnConcept() {
    let clickedPoint = NSPoint(x: 200, y: 300)
    let conceptPoint = clickedPoint

    let concept = Concept(stringValue: "Foo bar", point: conceptPoint)
    document.concepts.append(concept)

    let clickEvent = createMouseEvent(clickCount: 1, location: clickedPoint)

    canvasViewController.mouseDown(with: clickEvent)

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: concept))
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

    _ = canvasViewController.control(
      textField,
      textView: NSTextView(),
      doCommandBy: #selector(NSResponder.insertNewline(_:))
    )

    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }
}

// MARK: - CanvasViewController: StateManagerDelegate Tests

//protocol CanvasStateController {
//  
//}
//
//class CanvasViewControllerTransitionLogic: MockMethodCalls {
//  let controller: CanvasStateController
//  var methodCalls: [String : Int]
//  
//  init(controller: CanvasStateController) {
//    self.controller = controller
//    self.methodCalls = [String : Int]()
//  }
//}
//
//extension CanvasViewControllerTransitionLogic: StateManagerDelegate {
//  func transitionSuccesfull() {}
//  func transitionedToNewConcept(fromState: CanvasState) {}
//  func transitionedToCanvasWaiting(fromState: CanvasState) {}
//  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: NSPoint, text: NSAttributedString) {}
//  func transitionedToSelectedElements(fromState: CanvasState) {}
//  func transitionedToSelectedElementsSavingChanges(fromState: CanvasState) {}
//}

//extension CanvasViewControllerTests {
//  func testTransitionedToNewConceptFromCanvasWaiting() {
//    
//    let newConceptPoint = NSPoint(x: 300, y: 400)
//    canvasViewController.currentState = .newConcept(point: newConceptPoint)
//    canvasViewController.transitionedToNewConcept(fromState: .canvasWaiting)
// 
//    
//    
//    // What should happen then:
//    // From canvasWaiting
//    // - show text field at point
//    // From newConcept
//    // - remove previous text field value
//    // - show textfield to point
//    // From selectedElement
//    // - unselectAll elements
//    // - show textfield at point
//  }
//}

// MARK - CanvasViewControllers: Transition Acction Tests

extension CanvasViewControllerTests {
  func testShowTextFieldAt() {
    let clickedPoint = NSPoint(x: 400, y: 300)
    canvasViewController.showTextField(atPoint: clickedPoint)

    XCTAssertFalse(canvasViewController.textField.isHidden)
    XCTAssert(canvasViewController.textField.isEditable)
    XCTAssertEqual(canvasViewController.textField.frame.center, clickedPoint)
  }

  func testDismissTextField() {
    let textFieldCenter = NSPoint(x: 400, y: 300)
    let textField = canvasViewController.textField
    textField.frame = NSRect(center: textFieldCenter, size: NSSize(width: 60, height: 40))
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
    let conceptCenterPoint = NSPoint(x: 300, y: 400)

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
    let conceptCenterPoint = NSPoint(x: 300, y: 400)

    let successfullSave = canvasViewController.saveConcept(
      text: attributedString,
      atPoint: conceptCenterPoint
    )

    XCTAssertFalse(successfullSave)
    XCTAssertEqual(document.concepts.count, 0)
  }
}
