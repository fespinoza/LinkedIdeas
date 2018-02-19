//
//  CanvasViewController+StateManagerDelegate.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

// MARK: - CanvasViewController+StateManagerDelegate

extension CanvasViewController: StateManagerDelegate {
  func transitionedToResizingConcept(fromState: CanvasState) {
  }

  func transitionSuccesfull() {
    reRenderCanvasView()
  }

  func transitionedToNewConcept(fromState: CanvasState) {
    guard case .newConcept(let point) = currentState else {
      return
    }

    commonTransitionBehavior(fromState)

    showTextView(atPoint: point)
  }

  func transitionedToCanvasWaiting(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
  }

  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: CGPoint, text: NSAttributedString) {
    let mode = conceptMode(from: text)
    dismissTextView()

    if let concept = saveConcept(text: text, atPoint: point) {
      concept.mode = mode
      safeTransiton {
        try stateManager.toSelectedElement(element: concept)
      }
    }
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
    guard case .selectedElement(var element) = currentState,
      let newText = textView.attributedString().copy() as? NSAttributedString else {
      return
    }

    if let concept = element as? Concept {
      concept.mode = conceptMode(from: newText)
    }

    element.attributedStringValue = newText
    dismissTextView()

    transitionedToSelectedElement(fromState: fromState)
  }

  func transitionedToEditingElement(fromState: CanvasState) {
    commonTransitionBehavior(fromState)

    guard case .editingElement(var element) = currentState else {
      return
    }

    element.isEditable = true

    if let concept = element as? Concept {
      showTextView(
        inRect: element.area,
        text: element.attributedStringValue,
        constrainedSize: concept.constrainedSize
      )
    } else {
      showTextView(atPoint: element.centerPoint, text: element.attributedStringValue)
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
      dismissTextView()
    case .editingElement(var element):
      element.isEditable = false
      dismissTextView()
    case .selectedElement(let element):
      unselect(elements: [element])
      dismissConstructionArrow()
    case .multipleSelectedElements(let elements):
      unselect(elements: elements)
    default:
      break
    }
  }

  // extract the max Size for the textView
  // if the text is longer than the maxSize width, it should be constrained
  // if not, there is no constrain applied
  private func conceptMode(from text: NSAttributedString) -> Concept.Mode {
    let textViewMaxWidth = textView.maxSize.width
    if text.size().width > textViewMaxWidth {
      return .modifiedWidth(width: textViewMaxWidth)
    } else {
      return .textBased
    }
  }
}
