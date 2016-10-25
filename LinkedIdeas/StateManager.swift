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
  // basic
  func transitionSuccesfull()
  
  // elements
  func unselectAllElements()
  
  // concepts
  func cancelConceptCreation()
  func saveConcept(text: NSAttributedString, atPoint: NSPoint) -> Bool
  
  // text field
  func showTextField(atPoint: NSPoint)
  func dismissTextField()
}

protocol NewStateManagerDelegate {
//  var stateManager: StateManager { get }
  
  func transitionSuccesfull()
  
  func transitionedToNewConcept(fromState: CanvasState)
  func transitionedToCanvasWaiting(fromState: CanvasState)
  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: NSPoint, text: NSAttributedString)
  func transitionedToSelectedElements(fromState: CanvasState)
}

enum CanvasState {
  case canvasWaiting
  case newConcept(point: NSPoint)
  case selectedElements(elements: [Element])
  
  func isSimilar(to state: CanvasState) -> Bool {
    switch (self, state) {
    case (.newConcept, .newConcept),
         (.selectedElements, .selectedElements),
         (.canvasWaiting, .canvasWaiting):
      return true
    default:
      return false
    }
  }
}

extension CanvasState: Equatable {
  static func == (lhs: CanvasState, rhs: CanvasState) -> Bool {
    switch (lhs, rhs) {
    case (.newConcept(let a), .newConcept(let b)) where a == b: return true
    case (.canvasWaiting, .canvasWaiting): return true
    case (.selectedElements(let a), .selectedElements(let b)):
      return a.map({ $0.identifier }) == b.map({ $0.identifier })
    default: return false
    }
  }
}

struct StateManager {
  var currentState: CanvasState {
    didSet { print("Transitioned to \(currentState)") }
  }
  var delegate: NewStateManagerDelegate?
  
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
      .newConcept(point: NSPoint.zero),
      .selectedElements(elements: [Element]())
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
  
  public mutating func toSelectedElements(elements: [Element]) throws {
    let possibleStates: [CanvasState] = [
      .canvasWaiting,
      .newConcept(point: NSPoint.zero),
      .selectedElements(elements: [Element]())
    ]
    
    let state = CanvasState.selectedElements(elements: elements)
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
