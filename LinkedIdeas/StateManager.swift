//
//  StateManager.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/10/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

enum CanvasTransitionError: Error {
  case invalidTransition(message: String)
}

protocol StateManagerDelegate {
  func transitionSuccesfull()

  func transitionedToNewConcept(fromState: CanvasState)
  func transitionedToCanvasWaiting(fromState: CanvasState)
  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: NSPoint, text: NSAttributedString)
  func transitionedToSelectedElement(fromState: CanvasState)
  func transitionedToSelectedElementSavingChanges(fromState: CanvasState)
  func transitionedToEditingElement(fromState: CanvasState)
  func transitionedToSelectingElements(fromState: CanvasState)
  func transitionedToMultipleSelectedElements(fromState: CanvasState)
}

enum CanvasState {
  case canvasWaiting
  case newConcept(point: NSPoint)
  case selectedElement(element: Element)
  case editingElement(element: Element)
  case multipleSelectedElements(elements: [Element])
  case creatingLink(fromConcept: Concept)
  case selectingElements(begin: NSPoint, end: NSPoint)
  case movingElements(elements: [Element])

  func isSimilar(to state: CanvasState) -> Bool {
    switch (self, state) {
    case (.newConcept, .newConcept),
         (.selectedElement, .selectedElement),
         (.canvasWaiting, .canvasWaiting),
         (.editingElement, .editingElement),
         (.multipleSelectedElements, .multipleSelectedElements),
         (.creatingLink, .creatingLink),
         (.selectingElements, .selectingElements),
         (.movingElements, .movingElements):
      return true
    default:
      return false
    }
  }
}

struct EmptyElement: Element {
  var identifier: String
  var rect: NSRect
  var isEditable: Bool
  var isSelected: Bool

  static let example = EmptyElement(
    identifier: "empty-element",
    rect: NSMakeRect(0, 0, 30, 40),
    isEditable: false,
    isSelected: false
  )
}

extension CanvasState: Equatable {
  static func == (lhs: CanvasState, rhs: CanvasState) -> Bool {
    switch (lhs, rhs) {
    case (.newConcept(let a), .newConcept(let b)) where a == b: return true
    case (.canvasWaiting, .canvasWaiting): return true
    case (.selectedElement(let a), .selectedElement(let b)):
      return a.identifier == b.identifier
    case (.editingElement(let a), .editingElement(let b)):
      return a.identifier == b.identifier
    case (.multipleSelectedElements(let a), .multipleSelectedElements(let b)):
      return a.map { $0.identifier } == b.map { $0.identifier }
    case (.creatingLink(let a), .creatingLink(let b)):
      return a == b
    case (.selectingElements(let aStart, let aEnd), .selectingElements(let bStart, let bEnd)):
      return aStart == bStart && aEnd == bEnd
    case (.movingElements(let a), .movingElements(let b)):
      return a.map { $0.identifier } == b.map { $0.identifier }
    default: return false
    }
  }
}

struct StateManager {
  var currentState: CanvasState {
    didSet { print("Transitioned to \(currentState)") }
  }
  var delegate: StateManagerDelegate?

  init(initialState: CanvasState) {
    currentState = initialState
  }

  public mutating func toNewConcept(atPoint point: NSPoint) throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .newConcept(point: NSPoint.zero)
    ]

    try transition(fromPossibleStates: possibleStates, toState: .newConcept(point: point)) { (oldState) in
      delegate?.transitionedToNewConcept(fromState: oldState)
    }
  }

  public mutating func toCanvasWaiting() throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .newConcept(point: NSPoint.zero),
      .editingElement(element: EmptyElement.example),
      .selectedElement(element: EmptyElement.example),
      .multipleSelectedElements(elements: [Element]()),
    ]

    try transition(fromPossibleStates: possibleStates, toState: .canvasWaiting) { (oldState) in
      delegate?.transitionedToCanvasWaiting(fromState: oldState)
    }
  }

  public mutating func toCanvasWaiting(savingConceptWithText text: NSAttributedString) throws {
    let oldState = currentState

    // TODO: this code can be re-written

    switch currentState {
    case .newConcept(let point):
      currentState = .canvasWaiting
      delegate?.transitionedToCanvasWaitingSavingConcept(fromState: oldState, point: point, text: text)
      delegate?.transitionSuccesfull()
    default:
      throw CanvasTransitionError.invalidTransition(
        message: "there is no transition from \(currentState) to 'canvasWaiting' saving concept"
      )
    }
  }

  public mutating func toSelectedElement(element: Element) throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .newConcept(point: NSPoint.zero),
      .selectedElement(element: EmptyElement.example),
      .editingElement(element: EmptyElement.example),
    ]

    let state = CanvasState.selectedElement(element: element)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToSelectedElement(fromState: oldState)
    }
  }
  
  public mutating func toSelectedElementSavingChanges(element: Element) throws {
    let possibleStates: [CanvasState] = [
      .editingElement(element: EmptyElement.example),
    ]
    
    let state = CanvasState.selectedElement(element: element)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToSelectedElementSavingChanges(fromState: oldState)
    }
  }
  
  public mutating func toSelectingElements(from: NSPoint, to: NSPoint) throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .selectingElements(begin: NSPoint.zero, end: NSPoint.zero)
    ]
    
    let state = CanvasState.selectingElements(begin: from, end: to)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToSelectingElements(fromState: oldState)
    }
  }
  
  public mutating func toMultipleSelectedElements(elements: [Element]) throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .multipleSelectedElements(elements: [Element]())
    ]
    
    let state = CanvasState.multipleSelectedElements(elements: elements)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToMultipleSelectedElements(fromState: oldState)
    }
  }
  
  public mutating func toEditingElement(element: Element) throws {
    let possibleStates: [CanvasState] = [
      .selectedElement(element: EmptyElement.example),
    ]
    
    let state = CanvasState.editingElement(element: element)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToEditingElement(fromState: oldState)
    }
  }
  
  private mutating func transition(fromPossibleStates validFromStates: [CanvasState], toState: CanvasState, onSuccess: (CanvasState) -> Void) throws {
    let oldState = currentState

    if let _ = validFromStates.index(where: { $0.isSimilar(to: oldState) }) {
      currentState = toState
      onSuccess(oldState)
      delegate?.transitionSuccesfull()
    } else {
      throw CanvasTransitionError.invalidTransition(
        message: "there is no transition from \(oldState) to '\(toState)'"
      )
    }
  }
}
