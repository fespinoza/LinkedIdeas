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

protocol StateManagerDelegate: class {
  func transitionSuccesfull()

  func transitionedToNewConcept(fromState: CanvasState)
  func transitionedToCanvasWaiting(fromState: CanvasState)
  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: NSPoint, text: NSAttributedString)
  func transitionedToCanvasWaitingDeletingElements(fromState: CanvasState)
  func transitionedToSelectedElement(fromState: CanvasState)
  func transitionedToSelectedElementSavingChanges(fromState: CanvasState)
  func transitionedToEditingElement(fromState: CanvasState)
  func transitionedToMultipleSelectedElements(fromState: CanvasState)
  func transitionedToResizingConcept(fromState: CanvasState)
}

enum CanvasState {
  case canvasWaiting
  case newConcept(point: NSPoint)
  case selectedElement(element: Element)
  case editingElement(element: Element)
  case multipleSelectedElements(elements: [Element])
  case resizingConcept(concept: Concept, withHandler: Handler, initialArea: NSRect)

  func isSimilar(to state: CanvasState) -> Bool {
    return state.description == self.description
  }
}

extension CanvasState: CustomStringConvertible {
  var description: String {
    switch self {
    case .canvasWaiting:
      return "canvasWaiting"
    case .editingElement:
      return "editingElement"
    case .multipleSelectedElements:
      return "multipleSelectedElements"
    case .newConcept:
      return "newConcept"
    case .resizingConcept:
      return "resizingConcept"
    case .selectedElement:
      return "selectedElement"
    }
  }

}

struct EmptyElement: Element {
  var stringValue: String { return attributedStringValue.string}
  var identifier: String
  var area: NSRect
  var isEditable: Bool
  var isSelected: Bool
  var centerPoint: NSPoint { return area.center }
  var attributedStringValue: NSAttributedString

  static let example = EmptyElement(
    identifier: "empty-element",
    area: NSRect(x: 0, y: 0, width: 30, height: 40),
    isEditable: false,
    isSelected: false,
    attributedStringValue: NSAttributedString(string: "")
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
    case (.resizingConcept(let a1, _, _), .resizingConcept(let a2, _, _)):
      return a1.identifier == a2.identifier
    default: return false
    }
  }
}

class StateManager {
  var currentState: CanvasState {
    didSet { print("Transitioned to \(currentState)") }
  }
  weak var delegate: StateManagerDelegate?

  init(initialState: CanvasState) {
    currentState = initialState
  }

  public func toNewConcept(atPoint point: NSPoint) throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .newConcept(point: NSPoint.zero),
      .selectedElement(element: EmptyElement.example)
    ]

    try transition(fromPossibleStates: possibleStates, toState: .newConcept(point: point)) { (oldState) in
      delegate?.transitionedToNewConcept(fromState: oldState)
    }
  }

  public func toCanvasWaiting() throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .newConcept(point: NSPoint.zero),
      .editingElement(element: EmptyElement.example),
      .selectedElement(element: EmptyElement.example),
      .multipleSelectedElements(elements: [Element]())
    ]

    try transition(fromPossibleStates: possibleStates, toState: .canvasWaiting) { (oldState) in
      delegate?.transitionedToCanvasWaiting(fromState: oldState)
    }
  }

  public func toCanvasWaiting(savingConceptWithText text: NSAttributedString) throws {
    let oldState = currentState

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

  public func toCanvasWaiting(deletingElements elements: [Element]) throws {
    let possibleStates: [CanvasState] = [
      .selectedElement(element: EmptyElement.example),
      .multipleSelectedElements(elements: [Element]())
    ]

    let state = CanvasState.canvasWaiting
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToCanvasWaitingDeletingElements(fromState: oldState)
    }
  }

  public func toSelectedElement(element: Element) throws {
    let possibleStates = [
      "canvasWaiting",
      "newConcept",
      "selectedElement",
      "editingElement",
      "multipleSelectedElements",
      "resizingConcept"
    ]

    let state = CanvasState.selectedElement(element: element)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToSelectedElement(fromState: oldState)
    }
  }

  public func toSelectedElementSavingChanges(element: Element) throws {
    let possibleStates: [CanvasState] = [
      .editingElement(element: EmptyElement.example)
    ]

    let state = CanvasState.selectedElement(element: element)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToSelectedElementSavingChanges(fromState: oldState)
    }
  }

  public func toMultipleSelectedElements(elements: [Element]) throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .selectedElement(element: EmptyElement.example),
      .multipleSelectedElements(elements: [Element]())
    ]

    let state = CanvasState.multipleSelectedElements(elements: elements)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToMultipleSelectedElements(fromState: oldState)
    }
  }

  public func toEditingElement(element: Element) throws {
    let possibleStates: [CanvasState] = [
      .selectedElement(element: EmptyElement.example)
    ]

    let state = CanvasState.editingElement(element: element)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToEditingElement(fromState: oldState)
    }
  }

  public func toResizingConcept(concept: Concept, handler: Handler) throws {
    let possibleStates: [CanvasState] = [
      .selectedElement(element: EmptyElement.example)
    ]

    let state = CanvasState.resizingConcept(concept: concept, withHandler: handler, initialArea: concept.area)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToResizingConcept(fromState: oldState)
    }
  }

  private func transition(
    fromPossibleStates validFromStateDescriptions: [String],
    toState: CanvasState,
    onSuccess: (CanvasState) -> Void
  ) throws {
    let oldState = currentState

    if validFromStateDescriptions.index(where: { $0 == oldState.description }) != nil {
      currentState = toState
      onSuccess(oldState)
      delegate?.transitionSuccesfull()
    } else {
      throw CanvasTransitionError.invalidTransition(
        message: "there is no transition from \(oldState) to '\(toState)'"
      )
    }
  }

  // TODO: remove this function
  private func transition(
    fromPossibleStates validFromStates: [CanvasState],
    toState: CanvasState,
    onSuccess: (CanvasState) -> Void
  ) throws {
    try transition(fromPossibleStates: validFromStates.map({ $0.description }), toState: toState, onSuccess: onSuccess)
  }
}
