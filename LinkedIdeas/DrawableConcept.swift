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

  func draw() {
    drawBackground()
    drawConceptText()
    drawSelectedRing()
  }

  func drawBackground() {
    NSColor.white.set()
    NSRectFill(conceptRect())
  }

  func drawConceptText() {
    NSColor.black.set()
    concept.attributedStringValue.draw(in: conceptRect())
  }

  func drawSelectedRing() {
    guard concept.isSelected else {
      return
    }

    NSColor.red.set()
    NSBezierPath(rect: conceptRect()).stroke()
  }

  func conceptRect() -> NSRect {
    return concept.rect
  }
}
