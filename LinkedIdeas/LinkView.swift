//
//  LinkView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol ArrowDrawable {
  func constructArrow() -> Arrow
  func drawArrow()
}

class LinkView: NSView, CanvasElement, ArrowDrawable {
  // own
  var link: Link
  
  // CanvasElement
  var canvas: CanvasView
  
  init(link: Link, canvas: CanvasView) {
    self.link = link
    self.canvas = canvas
    super.init(frame: link.minimalRect)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(dirtyRect: NSRect) {
    drawArrow()
  }
  
  // MARK: - ArrowDrawable
  func constructArrow() -> Arrow {
    return Arrow(p1: link.originPoint, p2: link.targetPoint)
  }
  
  func drawArrow() {
    let arrowPath = constructArrow().bezierPath()
    NSColor.grayColor().set()
    arrowPath.fill()
  }
}
