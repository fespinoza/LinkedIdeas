//
//  CanvasViewController+StateManagerDelegate.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

// MARK: - CanvasViewController+StateManagerDelegate

extension CanvasViewController: StateManagerDelegate {
  func transitionSuccesfull() {
    reRenderCanvasView()
  }

  func transitionedToNewConcept(fromState: CanvasState) {
    guard case .newConcept(let point) = currentState else {
      return
    }

    commonTransitionBehavior(fromState)

    showTextField(atPoint: point)
  }

  func transitionedToCanvasWaiting(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
  }

  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: NSPoint, text: NSAttributedString) {
    dismissTextField()
    _ = saveConcept(text: text, atPoint: point)
  }

  func transitionedToSelectedElement(fromState: CanvasState) {
    commonTransitionBehavior(fromState)

    guard case .selectedElement(let element) = currentState else {
      return
    }

    select(elements: [element])
  }

  func transitionedToMultipleSelectedElements(fromState: CanvasState) {
    commonTransitionBehavior(fromState)

    guard case .multipleSelectedElements(let elements) = currentState else {
      return
    }

    select(elements: elements)
  }

  func transitionedToSelectedElementSavingChanges(fromState: CanvasState) {
    guard case .selectedElement(var element) = currentState else {
      return
    }
    element.attributedStringValue = textField.attributedStringValue
    dismissTextField()

    transitionedToSelectedElement(fromState: fromState)
  }

  func transitionedToEditingElement(fromState: CanvasState) {
    commonTransitionBehavior(fromState)

    guard case .editingElement(var element) = currentState else {
      return
    }

    element.isEditable = true

    switch element {
    case is Concept:
      showTextField(inRect: element.rect, text: element.attributedStringValue)
    default:
      showTextField(atPoint: element.point, text: element.attributedStringValue)
    }
  }

  func transitionedToCanvasWaitingDeletingElements(fromState: CanvasState) {
    commonTransitionBehavior(fromState)

    switch fromState {
    case .selectedElement(let element):
      delete(element: element)
    case .multipleSelectedElements(let elements):
      delete(elements: elements)
    default:
      break
    }
  }

  private func commonTransitionBehavior(_ fromState: CanvasState) {
    switch fromState {
    case .newConcept:
      dismissTextField()
    case .editingElement(var element):
      element.isEditable = false
      dismissTextField()
    case .selectedElement(let element):
      unselect(elements: [element])
      dismissConstructionArrow()
    case .multipleSelectedElements(let elements):
      unselect(elements: elements)
    default:
      break
    }
  }
}
