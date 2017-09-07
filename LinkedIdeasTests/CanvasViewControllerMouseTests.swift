//
//  CanvasViewControllerMouseTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

// MARK: - CanvasViewControllers: Mouse Tests

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
    let concept = Concept(stringValue: "Foo bar", centerPoint: NSPoint(x: 200, y: 300))
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

    let concept = Concept(stringValue: "Foo bar", centerPoint: conceptPoint)
    document.concepts.append(concept)

    let clickEvent = createMouseEvent(clickCount: 1, location: clickedPoint)

    canvasViewController.fullClick(event: clickEvent)

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: concept))
  }

  func testShiftClickOnAnotherConcept() {
    let oldConcept = Concept(stringValue: "Random", centerPoint: NSPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = NSPoint(x: 200, y: 300)
    let conceptPoint = clickedPoint

    let concept = Concept(stringValue: "Foo bar", centerPoint: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: oldConcept)

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .multipleSelectedElements(elements: [oldConcept, concept]))
  }

  func testShiftClickOnAlreadySelectedConcept() {
    let oldConcept = Concept(stringValue: "Random", centerPoint: NSPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = NSPoint(x: 200, y: 300)
    let conceptPoint = clickedPoint

    let concept = Concept(stringValue: "Foo bar", centerPoint: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .multipleSelectedElements(elements: [oldConcept, concept])

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .selectedElement(element: oldConcept))
  }

  func testShiftClickOnCanvas() {
    let oldConcept = Concept(stringValue: "Random", centerPoint: NSPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let clickedPoint = NSPoint(x: 200, y: 300)
    let conceptPoint = NSPoint(x: 600, y: 800)

    let concept = Concept(stringValue: "Foo bar", centerPoint: conceptPoint)
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: oldConcept)

    let shiftClickEvent = createMouseEvent(clickCount: 1, location: clickedPoint, shift: true)

    canvasViewController.fullClick(event: shiftClickEvent)

    XCTAssertEqual(canvasViewController.currentState, .canvasWaiting)
  }

  func testShiftDragFromOneConceptToAnotherToCreateLink() {
    let oldConcept = Concept(stringValue: "Random", centerPoint: NSPoint(x: 20, y: 600))
    document.concepts.append(oldConcept)

    let conceptPoint = NSPoint(x: 600, y: 800)

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

  func testDragRightHandlerForASelectedConcept() {
    let concept = Concept(stringValue: "Foo bar", centerPoint: NSPoint(x: 200, y: 300))
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
    let concept = Concept(stringValue: "Foo bar", centerPoint: NSPoint(x: 200, y: 300))
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
      Concept(stringValue: "Random", centerPoint: NSPoint(x: 20, y: 600)),
      Concept(stringValue: "Foo bar", centerPoint: NSPoint(x: 600, y: 800)),
      Concept(stringValue: "Another", centerPoint: NSPoint(x: 300, y: 400))
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
