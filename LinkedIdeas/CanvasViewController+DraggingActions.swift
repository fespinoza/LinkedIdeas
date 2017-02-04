//
//  Dragging.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

// MARK: - CanvasViewController+DraggingActions
extension CanvasViewController {
  // Action: what do the actions do
  // what are the effects, **commands** that happen
  // those **commands** change the state of the application
  // resulting in a need to refresh the view
  
  // MARK: Single Concept
  
  func drag(concept: Concept, toPoint dragToPoint: NSPoint) {
    if didDragStart == false { didDragStart = true }
    
    concept.point = dragToPoint
  }
  
  func endDrag(forConcept concept: Concept, toPoint: NSPoint) {
    document.move(concept: concept, toPoint: toPoint)
  }
  
  // MARK: Multiple Concepts
  
  func drag(concepts: [Concept], toPoint dragToPoint: NSPoint) {
    if let dragFromPoint = dragStartPoint, didDragStart {
      // Actual dragging
      let deltaX = dragToPoint.x - dragFromPoint.x
      let deltaY = dragToPoint.y - dragFromPoint.y
      
      dragStartPoint = dragToPoint
      
      for concept in concepts {
        concept.point = concept.point.translate(deltaX: deltaX, deltaY: deltaY)
      }
    } else {
      // Start dragging
      for concept in concepts { concept.beforeMovingPoint = concept.point }
      
      didDragStart = true
      dragStartPoint = dragToPoint
    }
  }
  
  func endDrag(forConcepts concepts: [Concept], toPoint: NSPoint) {
    guard let oldDragStart = dragStartPoint,
          didDragStart else { return }
    
    for concept in concepts {
      let conceptPoint = concept.point
      let deltaX = toPoint.x - oldDragStart.x
      let deltaY = toPoint.y - oldDragStart.y
      concept.point = concept.beforeMovingPoint!
      document.move(
        concept: concept, toPoint: conceptPoint.translate(deltaX: deltaX, deltaY: deltaY)
      )
      concept.beforeMovingPoint = nil
    }
  }
  
  // MARK: Hovering Concepts
  
  func hoverConcepts(toPoint point: NSPoint) {
    if didDragStart == false {
      // start selecting elements
      didDragStart = true
      canvasView.selectFromPoint = point
    } else {
      canvasView.selectToPoint = point
      
      // Handle hover of concepts
      guard let selectionRect = canvasView.selectionRect else { return }
      
      let hoveringConcepts = matchedConcepts(inRect: selectionRect)
      
      for concept in document.concepts {
        concept.isSelected = hoveringConcepts?.index(of: concept) != nil
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
    didDragStart = false
    dragStartPoint = nil
    canvasView.selectFromPoint = nil
    canvasView.selectToPoint = nil
    canvasView.needsDisplay = true
  }
}
