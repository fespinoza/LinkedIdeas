//
//  CanvasView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

public protocol CanvasViewDataSource {
  var drawableElements: [DrawableElement] { get }

  func drawableElements(forRect: CGRect) -> [DrawableElement]
}

public class CanvasView: NSView {
  public override var isFlipped: Bool { return true }

  public override var isOpaque: Bool { return true }
  public var dataSource: CanvasViewDataSource?

  var selectFromPoint: CGPoint?
  var selectToPoint: CGPoint?
  var selectionRect: CGRect? {
    if let selectFromPoint = selectFromPoint, let selectToPoint = selectToPoint {
      return CGRect(point1: selectFromPoint, point2: selectToPoint)
    } else {
      return nil
    }
  }

  override public var acceptsFirstResponder: Bool { return true }

  var arrowStartPoint: CGPoint?
  var arrowEndPoint: CGPoint?
  var arrowColor: NSColor?

  override public func draw(_ dirtyRect: CGRect) {
    super.draw(dirtyRect)
    drawBackground(dirtyRect)
    drawElements(inRect: dirtyRect)
    drawSelectionRect()
    drawLinkConstructionArrow()
  }

  func drawElements(inRect dirtyRect: CGRect) {
    guard let dataSource = dataSource else {
      return
    }

    dataSource.drawableElements(forRect: dirtyRect).forEach({ $0.draw() })
  }

  func drawBackground(_ dirtyRect: CGRect) {
    NSColor.windowBackgroundColor.set()
    dirtyRect.fill()
  }

  func drawSelectionRect() {
    guard let selectionRect = selectionRect else {
      return
    }

    let borderColor = DefaultColors.selectionGroup
    let backgroundColor = DefaultColors.selectionGroup.withAlphaComponent(0.5)
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
      DefaultColors.linkConstructionColor.set()
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
