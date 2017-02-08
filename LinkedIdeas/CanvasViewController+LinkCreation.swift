//
//  CanvasViewController+LinkCreation.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 06/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

//## States + Transitions
//
//- **selectedElement** -> "shift+drag" -> "drag release" -> **creating Link** -> "press enter" -> **link saved** -> **selected Element (link)**
//
//- **selected element** + "press ENTER" event => **editing element**
//- **selected element** + "press DELETE" event => **canvas waiting** + deletion of element
//
//- **link saved**:
//- concept A is not selected
//- concept B is not selected
//- link A+B is selected

// MARK: CanvasViewController+LinkCreation
extension CanvasViewController {
  func creationArrowForLink(toPoint point: NSPoint) {
    if let _ = canvasView.arrowStartPoint {
      canvasView.arrowEndPoint = point
    } else {
      canvasView.arrowStartPoint = point
    }
    didDragStart = true
    reRenderCanvasView()
  }
  
  func createTemporaryLink(fromConcept: Concept, toConcept: Concept) {
    // Transition to CreatingLink
//    safeTransiton { try stateManager.toNewLink() }
  }

  func saveLink() {
    // Transition to CanvasWaiting (saving link)
//    safeTransiton { try stateManager.toCanvasWaiting() }
  }
  
  func cancelLinkCreation() {
    dismissTextField()
    canvasView.arrowColor = nil
    canvasView.arrowStartPoint = nil
    canvasView.arrowEndPoint = nil
  }

  func dismissConstructionArrow() {
    canvasView.arrowStartPoint = nil
    canvasView.arrowEndPoint = nil
    reRenderCanvasView()
  }
}
