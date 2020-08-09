//
//  CanvasViewControllerMouseTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas_Shared
@testable import LinkedIdeas

extension CanvasViewController {
  /// This is a good way to "insert" text into a text view simulating user input
  func setTestText(_ text: String) {
    // also need to ensure that the `viewDidLoad` is called to
    // setup the delegates correctly
    viewDidLoad()
    textStorage.insert(NSAttributedString(string: text), at: 0)
  }
}

// MARK: - CanvasViewControllers: Mouse Tests

extension CanvasViewControllerTests {
  func testDoubleClickInCanvas() {
    let clickedPoint = CGPoint(x: 200, y: 300)

    let mouseEvent = createMouseEvent(clickCount: 2, location: clickedPoint)

    canvasViewController.mouseDown(with: mouseEvent)

    XCTAssertEqual(canvasViewController.currentState, .newConcept(point: clickedPoint))
  }

  func testSingleClickInCanvasWhenConceptIsBeingCreated() {
    canvasViewController.currentState = .newConcept(point: CGPoint.zero)
    canvasViewController.setTestText("New Foo Bar")

    let clickedPoint = CGPoint(x: 200, y: 300)
    let mouseEvent = createMouseEvent(clickCount: 1, location: clickedPoint)

    canvasViewController.mouseDown(with: mouseEvent)

    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
    XCTAssertEqual(document.concepts.map(\.stringValue), ["New Foo Bar"])
  }

  func testSingleClickOnCanvasWhenConceptIsSelected() {
    let concept = Concept(stringValue: "Foo bar", centerPoint: CGPoint(x: 200, y: 300))
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: concept)

    let clickedPoint = CGPoint(x: 10, y: 20)
    let clickEvent = createMouseEvent(clickCount: 1, location: clickedPoint)

    canvasViewController.mouseDown(with: clickEvent)

    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }

  func testSingleClickOnConcept() {
    let clickedPoint = CGPoint(x: 200, y: 300)
    let conceptPoint = clickedPoint

    let concept = Concept(stringValue: "Foo bar", centerPoint: conceptPoint)
    document.concepts.append(concept)

    let clickEvent = createMouseEvent(clickCount: 1, location: clickedPoint)

    canvasViewController.fullClick(event: clickEvent)

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: concept))
  }

  func testShiftClickOnAnotherConcept() {
    let oldConcept = Concept(stringValue: "#1 selected", centerPoint: CGPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = CGPoint(x: 200, y: 300)
    let conceptPoint = clickedPoint

    let concept = Concept(stringValue: "#2 selected", centerPoint: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: oldConcept)

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .multipleSelectedElements(elements: [oldConcept, concept]))
  }

  func testShiftClickOnAlreadySelectedConcept() {
    let oldConcept = Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = CGPoint(x: 200, y: 300)
    let conceptPoint = clickedPoint

    let concept = Concept(stringValue: "Foo bar", centerPoint: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .multipleSelectedElements(elements: [oldConcept, concept])

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: oldConcept))
  }

  func testShiftClickOnCanvas() {
    let oldConcept = Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = CGPoint(x: 200, y: 300)
    let conceptPoint = CGPoint(x: 600, y: 800)

    let concept = Concept(stringValue: "Foo bar", centerPoint: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: oldConcept)

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }

  func testShiftDragFromOneConceptToAnotherToCreateLink() {
    let oldConcept = Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let conceptPoint = CGPoint(x: 600, y: 800)

    let concept = Concept(stringValue: "Foo bar", centerPoint: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.mouseDown(with: createMouseEvent(clickCount: 1, location: oldConcept.centerPoint, shift: true))
    canvasViewController.mouseDragged(
      with: createMouseEvent(
        clickCount: 1,
        location: oldConcept.centerPoint.translate(deltaX: 10, deltaY: 20),
        shift: true
      )
    )
    canvasViewController.mouseDragged(with: createMouseEvent(clickCount: 1, location: concept.centerPoint, shift: true))
    canvasViewController.mouseUp(with: createMouseEvent(clickCount: 1, location: concept.centerPoint, shift: true))

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

  func testShiftDragFromOneConceptToAnotherToCreateLinkWhileAnotherConceptIsSelected() {
    // Given
    let concepts = [
      Concept(stringValue: "#1", centerPoint: CGPoint(x: 20, y: 600)),
      Concept(stringValue: "#2", centerPoint: CGPoint(x: 120, y: 1600)),
      Concept(stringValue: "#3", centerPoint: CGPoint(x: 200, y: 300)),
    ]
    concepts.forEach { document.concepts.append($0) }
    canvasViewController.currentState = .selectedElement(element: concepts[0])

    // When
    canvasViewController.mouseDown(
      with: createMouseEvent(clickCount: 1, location: concepts[1].centerPoint, shift: true)
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(clickCount: 1, location: concepts[1].centerPoint, shift: true)
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(
        clickCount: 1, location: concepts[1].centerPoint.translate(deltaX: 1, deltaY: 2), shift: true
      )
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(
        clickCount: 1,
        location: concepts[1].centerPoint.translate(deltaX: 10, deltaY: 20),
        shift: true
      )
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(clickCount: 1, location: concepts[2].centerPoint, shift: true)
    )
    canvasViewController.mouseUp(with: createMouseEvent(clickCount: 1, location: concepts[2].centerPoint, shift: true))

    // Then
    switch canvasViewController.currentState {
    case .selectedElement(let element):
      if let link = element as? Link {
        XCTAssertEqual(link.origin, concepts[1])
        XCTAssertEqual(link.target, concepts[2])
      } else {
        Swift.print(element)
        XCTFail("a link should have been created an selected")
      }
    default:
      XCTFail("current state should be selected element, not \(canvasViewController.currentState)")
    }
  }

  func testDragRightHandlerForASelectedConcept() {
    let concept = Concept(stringValue: "Foo bar", centerPoint: CGPoint(x: 200, y: 300))
    let initialConceptArea = concept.area
    document.concepts.append(concept)

    concept.isSelected = true
    canvasViewController.currentState = .selectedElement(element: concept)

    // when drag
    guard let rightHandler = concept.rightHandler else {
      XCTFail("❌ the concept is supposed to be selected, then the right handler should be available")
      return
    }

    let clickedPoint = rightHandler.area.center

    canvasViewController.mouseDown(
      with: createMouseEvent(clickCount: 1, location: clickedPoint)
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(clickCount: 1, location: clickedPoint.translate(deltaX: 10, deltaY: 0))
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(clickCount: 1, location: clickedPoint.translate(deltaX: 20, deltaY: 10))
    )
    canvasViewController.mouseUp(
      with: createMouseEvent(clickCount: 1, location: clickedPoint.translate(deltaX: 20, deltaY: 10))
    )

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: concept))
    XCTAssertNotEqual(initialConceptArea, concept.area)
  }

  func testDragLeftHandlerForASelectedConcept() {
    let concept = Concept(stringValue: "Foo bar", centerPoint: CGPoint(x: 200, y: 300))
    let initialConceptArea = concept.area
    document.concepts.append(concept)

    concept.isSelected = true
    canvasViewController.currentState = .selectedElement(element: concept)

    // when drag
    guard let leftHandler = concept.leftHandler else {
      XCTFail("❌ the concept is supposed to be selected, then the left handler should be available")
      return
    }

    let clickedPoint = leftHandler.area.center

    canvasViewController.mouseDown(
      with: createMouseEvent(clickCount: 1, location: clickedPoint)
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(clickCount: 1, location: clickedPoint.translate(deltaX: -10, deltaY: 0))
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(clickCount: 1, location: clickedPoint.translate(deltaX: -20, deltaY: 10))
    )
    canvasViewController.mouseUp(
      with: createMouseEvent(clickCount: 1, location: clickedPoint.translate(deltaX: -20, deltaY: 10))
    )

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: concept))
    XCTAssertNotEqual(initialConceptArea, concept.area)
  }

  func testShiftDragFromOneConceptToAnotherToCreateLinkWhenAnotherLinkIsSelected() {
    let concepts = [
      Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600)),
      Concept(stringValue: "Foo bar", centerPoint: CGPoint(x: 600, y: 800)),
      Concept(stringValue: "Another", centerPoint: CGPoint(x: 300, y: 400)),
    ]
    concepts.forEach {
      document.concepts.append($0)
    }
    let link = Link(origin: concepts[0], target: concepts[1])
    document.links.append(link)

    canvasViewController.currentState = .selectedElement(element: link)

    canvasViewController.mouseDown(
      with: createMouseEvent(clickCount: 1, location: concepts[1].centerPoint, shift: true)
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(
        clickCount: 1,
        location: concepts[1].centerPoint.translate(deltaX: 10, deltaY: 20),
        shift: true
      )
    )
    canvasViewController.mouseDragged(
      with: createMouseEvent(clickCount: 1, location: concepts[2].centerPoint, shift: true)
    )
    canvasViewController.mouseUp(with: createMouseEvent(clickCount: 1, location: concepts[2].centerPoint, shift: true))

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
