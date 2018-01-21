//
//  File.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

public struct DrawableConcept: DrawableElement {
  let concept: GraphConcept

  public var drawingBounds: CGRect { return concept.area }

  public func draw() {
    drawBackground()
    concept.draw()
    drawSelectedRing()
    drawForDebug()
  }

  func drawBackground() {
    NSColor.white.set()
    drawingBounds.fill()
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

    NSColor(red: 146 / 255, green: 178 / 255, blue: 254 / 255, alpha: 1).set()
    let bezierPath = NSBezierPath(rect: drawingBounds)
    bezierPath.lineWidth = 1
    bezierPath.stroke()

    concept.leftHandler?.draw()
    concept.rightHandler?.draw()
  }

  public func drawForDebug() {
    if isDebugging() {
      drawDebugHelpers()
      drawCenteredDotAtPoint(concept.centerPoint, color: NSColor.red)
    }
  }
}
