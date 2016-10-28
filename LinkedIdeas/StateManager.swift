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
  func transitionedToSelectedElements(fromState: CanvasState)
}

enum CanvasState {
  case canvasWaiting
  case newConcept(point: NSPoint)
  case selectedElement(element: Element)
  
  func isSimilar(to state: CanvasState) -> Bool {
    switch (self, state) {
    case (.newConcept, .newConcept),
         (.selectedElement, .selectedElement),
         (.canvasWaiting, .canvasWaiting):
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
      .selectedElement(element: EmptyElement.example)
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
      .selectedElement(element: EmptyElement.example)
    ]
    
    let state = CanvasState.selectedElement(element: element)
    try transition(fromPossibleStates: possibleStates, toState: state) { (oldState) in
      delegate?.transitionedToSelectedElements(fromState: oldState)
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
