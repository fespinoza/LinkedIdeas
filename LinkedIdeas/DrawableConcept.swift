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
    NSRectFill(concept.rect)
  }

  func drawConceptText() {
    NSColor.black.set()
    concept.attributedStringValue.draw(at: concept.rect.origin)
  }

  func drawSelectedRing() {
    guard concept.isSelected else {
      return
    }

    NSColor.red.set()
    NSBezierPath(rect: concept.rect).stroke()
  }
}
