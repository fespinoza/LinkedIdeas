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
        switch currentState {
        case .selectedElement(let selectedElement):
          if !event.modifierFlags.contains(.shift) || (selectedElement as? Link) != nil {
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
      if !event.modifierFlags.contains(.shift) {
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
      } else {
        // click
        if let targetConcept = clickedSingleConcept(atPoint: point) {
          // shift + click on concept
          if event.modifierFlags.contains(.shift) {
            let elements = [element, targetConcept]
            if (element as? Concept) != targetConcept {
              safeTransiton {
                try stateManager.toMultipleSelectedElements(elements: elements)
              }
            } else {
              safeTransiton { try stateManager.toCanvasWaiting() }
            }
          }
          // else: just single click on concept, do nothing
        } else {
          safeTransiton { try stateManager.toCanvasWaiting() }
        }
      }
    case .multipleSelectedElements(var elements):
      guard let concepts = elements as? [Concept] else {
        return
      }

      if didDragStart() {
        endDrag(forConcepts: concepts, toPoint: point)
      } else {
        // shift+click
        if let targetConcept = clickedSingleConcept(atPoint: point) {
          let elementAlreadySelected = elements.contains(where: { (element) -> Bool in
            return (element as? Concept) == targetConcept
          })

          if elementAlreadySelected {
            // unselect from group
            elements.remove(at: elements.index(where: { (element) -> Bool in
              return (element as? Concept) == targetConcept
            })!)

            if elements.count > 1 {
              safeTransiton {
                try stateManager.toMultipleSelectedElements(elements: elements)
              }
            } else {
              safeTransiton {
                try stateManager.toSelectedElement(element: elements.first!)
              }
            }
          } else {
            elements.append(targetConcept)

            safeTransiton {
              try stateManager.toMultipleSelectedElements(elements: elements)
            }
          }
        } else {
          safeTransiton { try stateManager.toCanvasWaiting() }
        }
      }
    case .canvasWaiting:
      selectHoveredConcepts()

    default:
      return
    }

    resetDraggingConcepts()
  }
}
