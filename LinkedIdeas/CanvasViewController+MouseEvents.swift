//
//  CanvasViewController+MouseEvents.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

// MARK: - CanvasViewController+MouseEvents

extension CanvasViewController {
  override func mouseDown(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)

    if event.isSingleClick() {
      if let clickedElements = clickedElements(atPoint: point) {
        if !currentState.isSimilar(to: .multipleSelectedElements(elements: [Element]())) {
          safeTransiton {
            try stateManager.toSelectedElement(element: clickedElements.first!)
          }
        }

      } else {
        safeTransiton {
          try stateManager.toCanvasWaiting()
        }

      }
    } else if event.isDoubleClick() {
      if let element = clickedSingleElement(atPoint: point) {
        if !element.isEditable {
          safeTransiton { try stateManager.toEditingElement(element: element) }
        } else {
          safeTransiton { try stateManager.toSelectedElement(element: element) }
        }
      } else {
        safeTransiton { try stateManager.toNewConcept(atPoint: point) }
      }
    }
  }

  override func mouseDragged(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)

    switch currentState {
    case .selectedElement(let element):
      guard let concept = element as? Concept else {
        return
      }

      if isDragShiftEvent(event) {
        creationArrowForLink(toPoint: point)
        didShiftDragStart = true
        if let hoveredConcepts = clickedConcepts(atPoint: point) {
          select(elements: hoveredConcepts)
        } else {
          unselect(elements: document.concepts.filter { $0 != concept })
        }
      } else {
        drag(concept: concept, toPoint: point)
      }

    case .multipleSelectedElements(let elements):
      guard let concepts = elements as? [Concept] else {
        return
      }
      drag(concepts: concepts, toPoint: point)

    case .canvasWaiting:
      hoverConcepts(toPoint: point)

    default:
      return
    }

    reRenderCanvasView()
  }

  override func mouseUp(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)

    switch currentState {
    case .selectedElement(let element):
      guard let concept = element as? Concept, didDragStart() else {
        return
      }

      if isDragShiftEvent(event) {
        if let targetConcept = clickedSingleConcept(atPoint: point) {
          targetConcept.isSelected = false

          let link = saveLink(fromConcept: concept, toConcept: targetConcept)
          dismissConstructionArrow()
          safeTransiton {
            try stateManager.toSelectedElement(element: link)
          }
        } else {
          safeTransiton { try stateManager.toCanvasWaiting() }
        }
      } else {
        endDrag(forConcept: concept, toPoint: point)
      }
    case .multipleSelectedElements(let elements):
      guard let concepts = elements as? [Concept] else {
        return
      }
      endDrag(forConcepts: concepts, toPoint: point)

    case .canvasWaiting:
      selectHoveredConcepts()

    default:
      return
    }

    resetDraggingConcepts()
  }
}
