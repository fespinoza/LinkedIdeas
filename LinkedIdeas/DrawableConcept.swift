//
//  File.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct DrawableConcept: DrawableElement {
  let concept: GraphConcept

  var drawingBounds: NSRect { return concept.rect }

  func draw() {
    drawBackground()
    drawConceptText()
    drawSelectedRing()
    drawForDebug()
  }

  func drawBackground() {
    NSColor.white.set()
    NSRectFill(drawingBounds)
  }

  func drawConceptText() {
    if !concept.isEditable {
      NSColor.black.set()
      concept.attributedStringValue.draw(in: drawingBounds)
    }
  }

  func drawSelectedRing() {
    guard concept.isSelected else {
      return
    }

    NSColor.red.set()
    NSBezierPath(rect: drawingBounds).stroke()
  }

  func drawForDebug() {
    if isDebugging() {
      drawDebugHelpers()
      drawCenteredDotAtPoint(concept.point, color: NSColor.red)
    }
  }
}
