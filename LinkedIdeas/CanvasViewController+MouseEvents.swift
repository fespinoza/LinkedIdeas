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
  // MARK: - Mouse Events
  override func mouseDown(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)

    if event.isSingleClick() {
      if let clickedElements = clickedElements(atPoint: point) {
        switch currentState {
        case .selectedElement(let selectedElement):
          if !isPressingShift(event: event) || (selectedElement as? Link) != nil {
            // single click, select another element
            safeTransiton {
              try stateManager.toSelectedElement(element: clickedElements.first!)
            }
          }
        // else: it can be additional selection or link creation
        case .multipleSelectedElements:
          // do nothing, because it's the init of multiple drag
          break
        default:
          // by default clicking (or shift clicking) an element selects it.
          safeTransiton {
            try stateManager.toSelectedElement(element: clickedElements.first!)
          }
        }

      } else {
        // if no concepts are clicked, then go to canvasWaiting
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
        if dragCount > 1 {
          creationArrowForLink(toPoint: point)
          didShiftDragStart = true
          if let hoveredConcepts = clickedConcepts(atPoint: point) {
            select(elements: hoveredConcepts)
          } else {
            unselect(elements: document.concepts.filter { $0 != concept })
          }
        } else {
          dragCount += 1
        }
      } else {
        drag(concept: concept, toPoint: point)
      }

    case .multipleSelectedElements(let elements):
      guard let concepts = elements as? [Concept] else {
        return
      }

      if !isPressingShift(event: event) {
        drag(concepts: concepts, toPoint: point)
      }

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
      guard let concept = element as? Concept else {
        return
      }

      if didDragStart() {
        if isDragShiftEvent(event) {
          whenClickedOnSingleConcept(atPoint: point, thenDo: { (targetConcept) in
            createNewLinkUp(fromConcept: concept, toConcept: targetConcept)
          })
        } else {
          endDrag(forConcept: concept, toPoint: point)
        }
      } else {
        // click
        whenClickedOnSingleConcept(atPoint: point, thenDo: { (targetConcept) in
          // shift + click on concept
          if isPressingShift(event: event) {
            shiftClickUp(onConcept: targetConcept, withSelectedElement: element)
          }
          // else: just single click on concept, do nothing
        })
      }
    case .multipleSelectedElements(let elements):
      guard let concepts = elements as? [Concept] else {
        return
      }

      if didDragStart() {
        endDrag(forConcepts: concepts, toPoint: point)
      } else {
        // shift+click
        whenClickedOnSingleConcept(atPoint: point, thenDo: { (targetConcept) in
          shiftClickUp(onConcept: targetConcept, withSelectedElements: elements)
        })
      }
    case .canvasWaiting:
      selectHoveredConcepts()

    default:
      return
    }

    resetDraggingConcepts()
  }

  // MARK: - mouse action helpers

  private func isPressingShift(event: NSEvent) -> Bool {
    return event.modifierFlags.contains(.shift)
  }

  private func createNewLinkUp(fromConcept: Concept, toConcept: Concept) {
    toConcept.isSelected = false

    let link = saveLink(fromConcept: fromConcept, toConcept: toConcept)
    dismissConstructionArrow()
    safeTransiton {
      try stateManager.toSelectedElement(element: link)
    }
  }

  private func shiftClickUp(onConcept targetConcept: Concept, withSelectedElements elements: [Element]) {
    guard var concepts = elements as? [Concept] else {
      return
    }

    if concepts.contains(targetConcept) {
      // unselect from group
      concepts.remove(at: concepts.index(of: targetConcept)!)

      if concepts.count > 1 {
        safeTransiton {
          try stateManager.toMultipleSelectedElements(elements: concepts)
        }
      } else {
        safeTransiton {
          try stateManager.toSelectedElement(element: concepts.first!)
        }
      }
    } else {
      concepts.append(targetConcept)

      safeTransiton {
        try stateManager.toMultipleSelectedElements(elements: concepts)
      }
    }
  }

  private func shiftClickUp(onConcept targetConcept: Concept, withSelectedElement element: Element) {
    let elements = [element, targetConcept]
    if (element as? Concept) != targetConcept {
      safeTransiton {
        try stateManager.toMultipleSelectedElements(elements: elements)
      }
    } else {
      safeTransiton { try stateManager.toCanvasWaiting() }
    }
  }

  /// handles the common case of evaluating if the clicked point matches a single concept then do some logic, otherwise
  /// it will transition to .canvasWaiting
  ///
  /// - Parameters:
  ///   - point: point from the click event
  ///   - thenDo: what actions you want to perform when there was actually a clicked concept
  private func whenClickedOnSingleConcept(atPoint point: NSPoint, thenDo: (Concept) -> Void) {
    if let targetConcept = clickedSingleConcept(atPoint: point) {
      thenDo(targetConcept)
    } else {
      safeTransiton { try stateManager.toCanvasWaiting() }
    }
  }
}
