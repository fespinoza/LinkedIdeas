//
//  CanvasViewController+LinkCreation.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 06/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

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
  
  func cancelLinkCreation() {
    dismissTextField()
    canvasView.arrowColor = nil
    canvasView.arrowStartPoint = nil
    canvasView.arrowEndPoint = nil
  }

  func dismissConstructionArrow() {
    canvasView.arrowStartPoint = nil
    canvasView.arrowEndPoint = nil
    canvasView.arrowColor = nil
    reRenderCanvasView()
  }
}
