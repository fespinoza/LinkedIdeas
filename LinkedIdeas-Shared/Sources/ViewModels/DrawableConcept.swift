//
//  File.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

#if os(iOS)
  import UIKit
  public typealias BezierPath = UIBezierPath

  extension CGRect {
    func fill() {
      BezierPath(rect: self).fill()
    }
  }
#else
  import AppKit
  public typealias BezierPath = NSBezierPath
#endif

public struct DrawableConcept: DrawableElement {
  let concept: Concept

  public init(concept: Concept) {
    self.concept = concept
  }

  public var drawingBounds: CGRect { return concept.area }

  public func draw() {
    drawBackground()
    concept.draw()
    drawSelectedRing()
    drawForDebug()
  }

  func drawBackground() {
    Color.windowBackgroundColor.set()
    drawingBounds.fill()
  }

  func drawSelectedRing() {
    guard concept.isSelected else {
      return
    }

    // TODO: dark mode
    Color(red: 146/255, green: 178/255, blue: 254/255, alpha: 1).set()
    let bezierPath = BezierPath(rect: drawingBounds)
    bezierPath.lineWidth = 1
    bezierPath.stroke()

    concept.leftHandler?.draw()
    concept.rightHandler?.draw()
  }

  public func drawForDebug() {
    if isDebugging() {
      drawDebugHelpers()
      drawCenteredDotAtPoint(concept.centerPoint, color: Color.red)
    }
  }
}
