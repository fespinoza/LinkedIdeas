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
  func createMouseEvent(clickCount: Int, location: NSPoint, shift: Bool = false) -> NSEvent {
    var flags: NSEventModifierFlags = .function

    if shift {
      flags = .shift
    }

    return NSEvent.mouseEvent(
      with: .leftMouseDown,
      location: location,
      modifierFlags: flags,
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
    let clickedPoint = NSPoint(x: 205, y: 305)

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

    canvasViewController.fullClick(event: clickEvent)

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: concept))
  }

  func testShiftClickOnAnotherConcept() {
    let oldConcept = Concept(stringValue: "Random", point: NSPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = NSPoint(x: 200, y: 300)
    let conceptPoint = clickedPoint

    let concept = Concept(stringValue: "Foo bar", point: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: oldConcept)

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .multipleSelectedElements(elements: [oldConcept, concept]))
  }

  func testShiftClickOnAlreadySelectedConcept() {
    let oldConcept = Concept(stringValue: "Random", point: NSPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = NSPoint(x: 200, y: 300)
    let conceptPoint = clickedPoint

    let concept = Concept(stringValue: "Foo bar", point: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .multipleSelectedElements(elements: [oldConcept, concept])

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: oldConcept))
  }

  func testShiftClickOnCanvas() {
    let oldConcept = Concept(stringValue: "Random", point: NSPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = NSPoint(x: 200, y: 300)
    let conceptPoint = NSPoint(x: 600, y: 800)

    let concept = Concept(stringValue: "Foo bar", point: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: oldConcept)

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }

  func testShiftDragFromOneConceptToAnotherToCreateLink() {
    let oldConcept = Concept(stringValue: "Random", point: NSPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let conceptPoint = NSPoint(x: 600, y: 800)

    let concept = Concept(stringValue: "Foo bar", point: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.mouseDown(with: createMouseEvent(clickCount: 1, location: oldConcept.point, shift: true))
    canvasViewController.mouseDragged(
      with: createMouseEvent(
        clickCount: 1,
        location: oldConcept.point.translate(deltaX: 10, deltaY: 20),
        shift: true
      )
    )
    canvasViewController.mouseDragged(with: createMouseEvent(clickCount: 1, location: concept.point, shift: true))
    canvasViewController.mouseUp(with: createMouseEvent(clickCount: 1, location: concept.point, shift: true))

    switch canvasViewController.currentState {
    case .selectedElement(let element):
      if (element as? Link) == nil {
        Swift.print(element)
        XCTFail("a link should have been created an selected")
      }
    default:
      XCTFail("current state should be selected element")
    }
  }

  func testShiftDragFromOneConceptToAnotherToCreateLinkWhenAnotherLinkIsSelected() {
    let concepts = [
      Concept(stringValue: "Random", point: NSPoint(x: 20, y: 600)),
      Concept(stringValue: "Foo bar", point: NSPoint(x: 600, y: 800)),
      Concept(stringValue: "Another", point: NSPoint(x: 300, y: 400))
    ]
    concepts.forEach {
      document.concepts.append($0)
    }
    let link = Link(origin: concepts[0], target: concepts[1])
    document.links.append(link)

    canvasViewController.currentState = .selectedElement(element: link)

    canvasViewController.mouseDown(
      with: createMouseEvent(clickCount: 1, location: concepts[1].point, shift: true)
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(
        clickCount: 1,
        location: concepts[1].point.translate(deltaX: 10, deltaY: 20),
        shift: true
      )
    )
    canvasViewController.mouseDragged(with: createMouseEvent(clickCount: 1, location: concepts[2].point, shift: true))
    canvasViewController.mouseUp(with: createMouseEvent(clickCount: 1, location: concepts[2].point, shift: true))

    switch canvasViewController.currentState {
    case .selectedElement(let element):
      if let selectedLink = element as? Link {
        XCTAssertNotEqual(selectedLink, link)
      } else {
        XCTFail("a link should have been created an selected")
      }
    default:
      XCTFail("current state should be selected element")
    }
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
