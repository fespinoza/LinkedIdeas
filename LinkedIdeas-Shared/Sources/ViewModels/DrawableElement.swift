//
//  DrawableElement.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import CoreGraphics

public protocol DrawableElement {
  var drawingBounds: CGRect { get }
  func draw()
  func drawForDebug()
}

extension DrawableElement {
  func isDebugging() -> Bool {
    return false
  }

  func drawDebugHelpers() {
    if isDebugging() {
      Color.lightGray.set()
      BezierPath(rect: drawingBounds).stroke()
    }
  }

  var area: CGFloat { return 8 }

  func debugDrawing() {
    drawBorderForRect(drawingBounds)
    drawCenteredDotAtPoint(drawingBounds.center)
  }

  func drawDotAtPoint(_ point: CGPoint) {
    Color.red.set()
    var x: CGFloat = point.x
    var y: CGFloat = point.y

    if x >= drawingBounds.maxX { x = drawingBounds.maxX - area }
    if y >= drawingBounds.maxY { y = drawingBounds.maxY - area }

    let rect = CGRect(
      origin: CGPoint(x: x, y: y),
      size: CGSize(width: area, height: area)
    )
    BezierPath(ovalIn: rect).fill()
  }

  func drawCenteredDotAtPoint(_ point: CGPoint, color: Color = Color.yellow) {
    color.set()
    var x: CGFloat = point.x - area / 2
    var y: CGFloat = point.y - area / 2

    if x >= drawingBounds.maxX { x = drawingBounds.maxX - area / 2 }
    if y >= drawingBounds.maxY { y = drawingBounds.maxY - area / 2 }

    let rect = CGRect(
      origin: CGPoint(x: x, y: y),
      size: CGSize(width: area, height: area)
    )
    BezierPath(ovalIn: rect).fill()
  }

  func drawBorderForRect(_ rect: CGRect) {
    Color.blue.set()

    let border = BezierPath()
    border.move(to: rect.bottomLeftPoint)
    border.line(to: rect.bottomRightPoint)
    border.line(to: rect.topRightPoint)
    border.line(to: rect.topLeftPoint)
    border.line(to: rect.bottomLeftPoint)
    border.stroke()
  }

  func drawFullRect(_ rect: CGRect) {
    rect.fill()
    drawBorderForRect(rect)
    drawCenteredDotAtPoint(rect.origin, color: Color.red)
    drawCenteredDotAtPoint(rect.center)
  }

}
