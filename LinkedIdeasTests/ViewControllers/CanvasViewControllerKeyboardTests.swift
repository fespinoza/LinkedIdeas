//
//  CanvasViewControllerKeyboardTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
import LinkedIdeas_Shared
@testable import LinkedIdeas

// MARK: - CanvasViewController Keyboard Based Tests

extension CanvasViewControllerTests {
  func testShiftEnterWhenCanvasIsWaiting() {
    canvasViewController.currentState = .canvasWaiting

    let enterKeyCode: UInt16 = 36
    canvasViewController.keyDown(with: createKeyboardEvent(keyCode: enterKeyCode, shift: true))

    switch canvasViewController.currentState {
    case .newConcept:
      break
    default:
      XCTFail("current state should be new Concept with random point")
    }
  }

  func testShiftEnterWhenConceptIsSelected() {
    let concept = Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600))
    document.concepts.append(concept)

    canvasViewController.currentState = .selectedElement(element: concept)

    let enterKeyCode: UInt16 = 36
    canvasViewController.keyDown(with: createKeyboardEvent(keyCode: enterKeyCode, shift: true))

    switch canvasViewController.currentState {
    case .newConcept:
      break
    default:
      XCTFail("current state should be new Concept with random point")
    }
  }

  func testTabSelectsFirstConceptOnCanvasWaiting() {
    let concepts = [
      Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600)),
      Concept(stringValue: "Foo bar", centerPoint: CGPoint(x: 600, y: 800)),
      Concept(stringValue: "Another", centerPoint: CGPoint(x: 300, y: 400)),
    ]
    concepts.forEach {
      document.concepts.append($0)
    }

    canvasViewController.currentState = .canvasWaiting

    let tabKeyCode: UInt16 = 48
    canvasViewController.keyDown(with: createKeyboardEvent(keyCode: tabKeyCode))

    switch canvasViewController.currentState {
    case .selectedElement(let element):
      if let selectedConcept = element as? Concept {
        XCTAssertEqual(selectedConcept, concepts[0])
      } else {
        XCTFail("a concept should have been selected")
      }
    default:
      XCTFail("current state should be selected element")
    }
  }

  func testTabSelectsNextConceptOnSelectedConcept() {
    let concepts = [
      Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600)),
      Concept(stringValue: "Foo bar", centerPoint: CGPoint(x: 600, y: 800)),
      Concept(stringValue: "Another", centerPoint: CGPoint(x: 300, y: 400)),
    ]
    concepts.forEach {
      document.concepts.append($0)
    }

    canvasViewController.currentState = .selectedElement(element: concepts[1])

    let tabKeyCode: UInt16 = 48
    canvasViewController.keyDown(with: createKeyboardEvent(keyCode: tabKeyCode))

    switch canvasViewController.currentState {
    case .selectedElement(let element):
      if let selectedConcept = element as? Concept {
        XCTAssertEqual(selectedConcept, concepts[2])
      } else {
        XCTFail("a concept should have been selected")
      }
    default:
      XCTFail("current state should be selected element")
    }
  }

  func testTabSelectsFirstConceptOnLastSelectedConcept() {
    let concepts = [
      Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600)),
      Concept(stringValue: "Foo bar", centerPoint: CGPoint(x: 600, y: 800)),
      Concept(stringValue: "Another", centerPoint: CGPoint(x: 300, y: 400)),
    ]
    concepts.forEach {
      document.concepts.append($0)
    }

    canvasViewController.currentState = .selectedElement(element: concepts[2])

    let tabKeyCode: UInt16 = 48
    canvasViewController.keyDown(with: createKeyboardEvent(keyCode: tabKeyCode))

    switch canvasViewController.currentState {
    case .selectedElement(let element):
      if let selectedConcept = element as? Concept {
        XCTAssertEqual(selectedConcept, concepts[0])
      } else {
        XCTFail("a concept should have been selected")
      }
    default:
      XCTFail("current state should be selected element")
    }
  }

  func testShiftTabSelectsPreviousConceptOnSelectedConcept() {
    let concepts = [
      Concept(stringValue: "Random", centerPoint: CGPoint(x: 20, y: 600)),
      Concept(stringValue: "Foo bar", centerPoint: CGPoint(x: 600, y: 800)),
      Concept(stringValue: "Another", centerPoint: CGPoint(x: 300, y: 400)),
    ]
    concepts.forEach {
      document.concepts.append($0)
    }

    canvasViewController.currentState = .selectedElement(element: concepts[1])

    let tabKeyCode: UInt16 = 48
    canvasViewController.keyDown(with: createKeyboardEvent(keyCode: tabKeyCode, shift: true))

    switch canvasViewController.currentState {
    case .selectedElement(let element):
      if let selectedConcept = element as? Concept {
        XCTAssertEqual(selectedConcept, concepts[0])
      } else {
        XCTFail("a concept should have been selected")
      }
    default:
      XCTFail("current state should be selected element")
    }
  }
}
