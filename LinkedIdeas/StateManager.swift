//
//  StateManager.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/10/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol StateManagerDelegate {
  // elemnts
  func unselectAllElements()
  
  // concepts
  func cancelConceptCreation()
  func saveConcept(text: NSAttributedString, atPoint: NSPoint) -> Bool
  
  // text field
  func showTextField(atPoint: NSPoint)
  func dismissTextField()
}

enum CanvasState {
  case canvasWaiting
  case newConcept(point: NSPoint)
  case selectedElements(elements: [Element])
}

extension CanvasState: Equatable {
  static func == (lhs: CanvasState, rhs: CanvasState) -> Bool {
    switch (lhs, rhs) {
    case (.newConcept(let a), .newConcept(let b)) where a == b: return true
    case (.canvasWaiting, .canvasWaiting): return true
    case (.selectedElements, .selectedElements): return true
    default: return false
    }
  }
}

struct StateManager {
  var currentState: CanvasState {
    didSet {
      print("Transitioned to \(currentState)")
    }
  }
  var delegate: StateManagerDelegate?
  
  init(initialState: CanvasState) {
    currentState = initialState
  }
  
  mutating func toNewConcept(atPoint point: NSPoint) -> Bool {
    switch currentState {
    case .canvasWaiting:
      break
    case .newConcept:
      delegate?.dismissTextField()
    case .selectedElements:
      delegate?.unselectAllElements()
    }
    
    delegate?.showTextField(atPoint: point)
    currentState = .newConcept(point: point)
    return true
  }
  
  mutating func saveNewConcept(text: NSAttributedString) -> Bool {
    switch currentState {
    case .newConcept(let point):
      guard let success = delegate?.saveConcept(text: text, atPoint: point) else {
        return false
      }
      delegate?.dismissTextField()
      currentState = .canvasWaiting
      return success
    default:
      return false
    }
  }
  
  mutating func cancelNewConcept() -> Bool {
    switch currentState {
    case .newConcept:
      currentState = .canvasWaiting
      
      delegate?.dismissTextField()
      return true
    default:
      return false
    }
  }
  
  mutating func select(elements: [Element]) -> Bool {
    switch currentState {
    case .canvasWaiting:
      guard elements.count > 0 else {
        return false
      }
      
      currentState = .selectedElements(elements: elements)
      return true
    default:
      return false
    }
  }
}
