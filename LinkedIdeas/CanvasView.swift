//
//  CanvasView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol DrawableElement {
  func draw()
}

protocol CanvasViewDataSource {
  var drawableElements: [DrawableElement] { get }
}

class CanvasView: NSView {
  
  var dataSource: CanvasViewDataSource?
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    drawBackground()
    
    if let dataSource = dataSource {
      for element in dataSource.drawableElements { element.draw() }
    }
  }
  
  func drawBackground() {
    NSColor.white.set()
    NSRectFill(bounds)
  }
}
