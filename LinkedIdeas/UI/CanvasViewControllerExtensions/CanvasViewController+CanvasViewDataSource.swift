//
//  CanvasViewController+CanvasViewDataSource.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

// MARK: - CanvasViewController+CanvasViewDataSource

extension CanvasViewController: CanvasViewDataSource {
  var drawableElements: [DrawableElement] {
    var elements: [DrawableElement] = []

    elements += document.concepts.map {
      DrawableConcept(concept: $0 as GraphConcept) as DrawableElement
    }

    elements += document.links.map {
      DrawableLink(link: $0 as GraphLink) as DrawableElement
    }

    return elements
  }

  func drawableElements(forRect containerRect: CGRect) -> [DrawableElement] {
    return drawableElements.filter({ containerRect.intersects($0.drawingBounds) })
  }
}
