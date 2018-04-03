//
//  CanvasViewController+MouseEvents.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

// MARK: - CanvasViewController+MouseEvents

extension CanvasViewController {
  fileprivate func clickedHandler(atPoint clickedPoint: CGPoint) -> Handler? {
    switch currentState {
    case .selectedElement(let element):
      guard let concept = element as? Concept,
        let leftHandler = concept.leftHandler,
        let rightHandler = concept.rightHandler else {
          break
      }

      if leftHandler.contains(clickedPoint) {
        return leftHandler
      } else if rightHandler.contains(clickedPoint) {
        return rightHandler
      }
    default:
      break
    }

    return nil
  }

  fileprivate func didClickOnHandler(atPoint clickedPoint: CGPoint) -> Bool {
    return clickedHandler(atPoint: clickedPoint) != nil
  }

  fileprivate func resize(concept: Concept, withHandler handler: Handler, toPoint point: CGPoint) {
    let previousConceptArea = concept.area

    switch handler.position {
    case .left:
      let previousMinX = previousConceptArea.origin.x
      let widthDiff = previousMinX - point.x

      concept.updateWidth(withDifference: widthDiff, fromLeft: true)
    case .right:
      let previousMaxX = previousConceptArea.origin.x + previousConceptArea.width
      let widthDiff = point.x - previousMaxX

      concept.updateWidth(withDifference: widthDiff)
    }
  }

  // MARK: - Mouse Events
  override func mouseDown(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)

    if event.isSingleClick() {
      if let handler = clickedHandler(atPoint: point), let concept = singleSelectedElement() as? Concept {
        safeTransiton {
          try stateManager.toResizingConcept(concept: concept, handler: handler)
        }
        return
      }

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

  // swiftlint:disable:next cyclomatic_complexity
  override func mouseDragged(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)

    switch currentState {
    case .selectedElement(let element):
      guard let concept = element as? Concept else {
        return
      }

      if isDragShiftEvent(event) {
        switch shiftDragEvent(for: dragCount) {
        case .simpleClick:
          dragCount += 1
        case .startDragging:
          try? updateSelectedConcept(at: point, withCurrentSelectedConcept: concept)
          dragCount += 1
        case .dragging:
          creationArrowForLink(toPoint: point)
          didShiftDragStart = true
          if let hoveredConcepts = clickedConcepts(atPoint: point) {
            select(elements: hoveredConcepts)
          } else {
            unselect(elements: document.concepts.filter { $0 != concept })
          }
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

    case .resizingConcept(let concept, let handler, _):
      resize(concept: concept, withHandler: handler, toPoint: point)
    default:
      return
    }

    reRenderCanvasView()
  }

  // swiftlint:disable:next cyclomatic_complexity
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

    case .resizingConcept(let concept, _, _):
      safeTransiton {
        try stateManager.toSelectedElement(element: concept)
      }

    default:
      return
    }

    resetDraggingConcepts()
  }

  // MARK: - mouse action helpers

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

  private func updateSelectedConcept(at point: CGPoint, withCurrentSelectedConcept concept: Concept) throws {
    whenClickedOnSingleConcept(atPoint: point, thenDo: { (newSelectedConcept) in
      if concept != newSelectedConcept {
        safeTransiton {
          try stateManager.toSelectedElement(element: newSelectedConcept)
        }
      }
    })
  }

  private enum ShiftDragEvent {
    case simpleClick
    case startDragging
    case dragging
  }

  private func shiftDragEvent(for dragCount: Int) -> ShiftDragEvent {
    guard dragCount > 0 else { return .simpleClick }

    if dragCount == 1 {
      return .startDragging
    } else {
      return .dragging
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
  private func whenClickedOnSingleConcept(atPoint point: CGPoint, thenDo: (Concept) -> Void) {
    if let targetConcept = clickedSingleConcept(atPoint: point) {
      thenDo(targetConcept)
    } else {
      safeTransiton { try stateManager.toCanvasWaiting() }
    }
  }
}
