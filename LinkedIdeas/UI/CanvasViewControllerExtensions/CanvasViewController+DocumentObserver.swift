//
//  CanvasViewController+DocumentObserver.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Foundation
import LinkedIdeas_Shared

// MARK: - CanvasViewController+DocumentObserver

extension CanvasViewController: DocumentObserver {
  func documentChanged(with element: Element) {
    reRenderCanvasView()
  }

  func documentChanged(with elements: [Element]) {
    reRenderCanvasView()
  }
}
