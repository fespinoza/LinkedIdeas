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
  func transitionedToResizingConcept(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
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

  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: NSPoint, text: NSAttributedString) {
    // extract the max Size for the textView
    // if the text is longer than the maxSize width, it should be constrained
    // if not, there is no constrain applied
    var conceptMode: Concept.Mode
    let textViewMaxWidth = textView.maxSize.width
    if text.size().width > textViewMaxWidth {
      conceptMode = .modifiedWidth(width: textViewMaxWidth)
    } else {
      conceptMode = .textBased
    }

    dismissTextView()

    if let concept = saveConcept(text: text, atPoint: point) {
      concept.mode = conceptMode
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

    var conceptMode: Concept.Mode
    let textViewMaxWidth = textView.maxSize.width
    if newText.size().width > textViewMaxWidth {
      conceptMode = .modifiedWidth(width: textViewMaxWidth)
    } else {
      conceptMode = .textBased
    }
    if let concept = element as? Concept {
      concept.mode = conceptMode
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

    switch element {
    case is Concept:
      guard let concept = element as? Concept else {
        return
      }
      // if the concept mode is
      // constrained, then pass the constraint
      // if not don't pass anything and it will be contrained to max visible area
      var constrainedSize: NSSize?
      switch concept.mode {
      case .modifiedWidth(let width):
        constrainedSize = NSSize(width: width, height: canvasView.bounds.height)
      case .textBased:
        constrainedSize = nil
      }
      showTextView(inRect: element.area, text: element.attributedStringValue, constrainedSize: constrainedSize)
    default:
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
}
