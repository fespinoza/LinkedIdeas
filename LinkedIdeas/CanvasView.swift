//
//  CanvasView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

public protocol CanvasViewDataSource {
  var drawableElements: [DrawableElement] { get }

  func drawableElements(forRect: NSRect) -> [DrawableElement]
}

public class CanvasView: NSView {

  public override var isOpaque: Bool { return true }
  public var dataSource: CanvasViewDataSource?

  var selectFromPoint: NSPoint?
  var selectToPoint: NSPoint?
  var selectionRect: NSRect? {
    if let selectFromPoint = selectFromPoint, let selectToPoint = selectToPoint {
      return NSRect(point1: selectFromPoint, point2: selectToPoint)
    } else {
      return nil
    }
  }

  override public var acceptsFirstResponder: Bool { return true }

  var arrowStartPoint: NSPoint?
  var arrowEndPoint: NSPoint?
  var arrowColor: NSColor?

  override public func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    drawBackground(dirtyRect)
    drawElements(inRect: dirtyRect)
    drawSelectionRect()
    drawLinkConstructionArrow()
  }

  func drawElements(inRect dirtyRect: NSRect) {
    guard let dataSource = dataSource else {
      return
    }

    dataSource.drawableElements(forRect: dirtyRect).forEach({ $0.draw() })
  }

  func drawBackground(_ dirtyRect: NSRect) {
    NSColor.white.set()
    NSRectFill(dirtyRect)
  }

  func drawSelectionRect() {
    guard let selectionRect = selectionRect else {
      return
    }

    let borderColor = NSColor(red: 0, green: 0, blue: 1, alpha: 1)
    let backgroundColor = NSColor(red: 0, green: 0, blue: 1, alpha: 0.5)
    let bezierPath = NSBezierPath(rect: selectionRect)

    borderColor.set()
    bezierPath.stroke()

    backgroundColor.set()
    bezierPath.fill()
  }

  func drawLinkConstructionArrow() {
    guard let arrowStartPoint = arrowStartPoint, let arrowEndPoint = arrowEndPoint else {
      return
    }

    let arrow = Arrow(point1: arrowStartPoint, point2: arrowEndPoint)

    if let arrowColor = arrowColor {
      arrowColor.set()
    } else {
      NSColor.blue.set()
    }

    arrow.bezierPath().stroke()
  }

  func cancelCreationArrow() {
    arrowStartPoint = nil
    arrowEndPoint = nil
    arrowColor = nil

    needsDisplay = true
  }

  override public func keyDown(with event: NSEvent) {
    super.keyDown(with: event)
  }
}
