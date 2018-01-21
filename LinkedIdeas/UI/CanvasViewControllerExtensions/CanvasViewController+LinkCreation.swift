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
  func creationArrowForLink(toPoint point: CGPoint) {
    if canvasView.arrowStartPoint == nil {
      canvasView.arrowStartPoint = point
    } else {
      canvasView.arrowEndPoint = point
    }
    startDragging()
    reRenderCanvasView()
  }

  func dismissConstructionArrow() {
    canvasView.cancelCreationArrow()
  }
}
