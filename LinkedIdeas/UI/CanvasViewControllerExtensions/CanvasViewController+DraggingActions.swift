//
//  Dragging.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

// MARK: - CanvasViewController+DraggingActions
extension CanvasViewController {
  func didDragStart() -> Bool {
    return dragCount > 1
  }

  func startDragging() {
    // drags with dragCount <= 1 will be ignored.
    dragCount = 2
  }

  // MARK: Single Concept

  func drag(concept: Concept, toPoint dragToPoint: CGPoint) {
    dragCount += 1

    if dragCount > 1 {
      concept.centerPoint = dragToPoint
    } else {
      concept.beforeMovingPoint = concept.centerPoint
    }
  }

  func endDrag(forConcept concept: Concept, toPoint: CGPoint) {
    if dragCount > 1 {
      if let originalPoint = concept.beforeMovingPoint {
        concept.centerPoint = originalPoint
        concept.beforeMovingPoint = nil
      }
      document.move(concept: concept, toPoint: toPoint)
    }
  }

  // MARK: Multiple Concepts

  func drag(concepts: [Concept], toPoint dragToPoint: CGPoint) {
    if let dragFromPoint = dragStartPoint, didDragStart() {
      // Actual dragging
      let deltaX = dragToPoint.x - dragFromPoint.x
      let deltaY = dragToPoint.y - dragFromPoint.y

      dragStartPoint = dragToPoint

      for concept in concepts {
        concept.centerPoint = concept.centerPoint.translate(deltaX: deltaX, deltaY: deltaY)
      }
    } else {
      // Start dragging
      for concept in concepts { concept.beforeMovingPoint = concept.centerPoint }

      startDragging()
      dragStartPoint = dragToPoint
    }
  }

  func endDrag(forConcepts concepts: [Concept], toPoint: CGPoint) {
    guard let oldDragStart = dragStartPoint,
          didDragStart() else { return }

    for concept in concepts {
      let conceptPoint = concept.centerPoint
      let deltaX = toPoint.x - oldDragStart.x
      let deltaY = toPoint.y - oldDragStart.y
      concept.centerPoint = concept.beforeMovingPoint!
      document.move(
        concept: concept, toPoint: conceptPoint.translate(deltaX: deltaX, deltaY: deltaY)
      )
      concept.beforeMovingPoint = nil
    }
  }

  // MARK: Hovering Concepts

  func hoverConcepts(toPoint point: CGPoint) {
    if didDragStart() == false {
      // start selecting elements
      startDragging()
      canvasView.selectFromPoint = point
    } else {
      canvasView.selectToPoint = point

      // Handle hover of concepts
      guard let selectionRect = canvasView.selectionRect else { return }

      let hoveringConcepts = matchedConcepts(inRect: selectionRect)

      for concept in document.concepts {
        concept.isSelected = hoveringConcepts?.firstIndex(of: concept) != nil
      }
    }
  }

  func selectHoveredConcepts() {
    guard let selectionRect = canvasView.selectionRect else { return }

    // select concepts that intersect with the selection rect
    if let concepts = matchedConcepts(inRect: selectionRect) {
      safeTransiton {
        try stateManager.toMultipleSelectedElements(elements: concepts)
      }
    } else {
      unselect(elements: document.concepts)
    }
  }

  // MARK: General drag operations
  func resetDraggingConcepts() {
    didShiftDragStart = false
    dragStartPoint = nil
    dragCount = 0
    canvasView.selectFromPoint = nil
    canvasView.selectToPoint = nil
    reRenderCanvasView()
  }
}
