//
//  ElementView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 07/04/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol StringEditableView {
  var textField: ResizingTextField { get }
  var textFieldSize: NSSize { get }
  var isTextFieldFocused: Bool { get set }

  func editingString() -> Bool
  func toggleTextFieldEditMode()
  func enableTextField()
  func disableTextField()
  func focusTextField()

  func drawString()

  func typeText(_ string: String)
  func pressEnterKey()
  func pressDeleteKey()
  func cancelEdition()
}

extension StringEditableView {
  func editingString() -> Bool {
    return !textField.isHidden
  }

  func enableTextField() {
    textField.isHidden = false
    textField.isEnabled = true
    focusTextField()
  }

  func disableTextField() {
    textField.isHidden = true
    textField.isEnabled = false
  }

  func typeText(_ string: String) {
    textField.stringValue = string
  }
}

protocol CanvasElement {
  var canvas: OldCanvasView { get }

  func pointInCanvasCoordinates(_ point: NSPoint) -> NSPoint
}

extension CanvasElement {
  func pointInCanvasCoordinates(_ point: NSPoint) -> NSPoint {
    return canvas.pointInCanvasCoordinates(point)
  }
}

protocol ConceptViewProtocol {
  var concept: Concept { get }

  func updateFrameToMatchConcept()
}

protocol DraggableElement {
  var isDragging: Bool { get set }
  var initialPoint: NSPoint? { get set }
  var draggableDelegate: DraggableElementDelegate? { get }

  func dragStart(_ initialPoint: NSPoint, performCallback: Bool)
  func dragTo(_ point: NSPoint, performCallback: Bool)
  func dragEnd(_ lastPoint: NSPoint, performCallback: Bool)
}

struct DragEvent {
  let fromPoint: NSPoint
  let toPoint: NSPoint

  var deltaX: CGFloat { return toPoint.x - fromPoint.x }
  var deltaY: CGFloat { return toPoint.y - fromPoint.y }

  func translatePoint(_ point: NSPoint) -> NSPoint {
    return point.translate(deltaX: deltaX, deltaY: deltaY)
  }
}

protocol DraggableElementDelegate {
  func dragStartCallback(_ draggableElementView: DraggableElement, dragEvent: DragEvent)
  func dragToCallback(_ draggableElementView: DraggableElement, dragEvent: DragEvent)
  func dragEndCallback(_ draggableElementView: DraggableElement, dragEvent: DragEvent)
}

protocol ClickableView {
  func click(_ point: NSPoint)
  func doubleClick(_ point: NSPoint)
  func shiftClick(_ point: NSPoint)
}

extension ClickableView {
  func shiftClick(_ point: NSPoint) {}
}

protocol CanvasConceptsActions {
  func deselectConcepts()
  func removeNonSavedConcepts()
  func createConceptAt(_ point: NSPoint)
  func markConceptsAsNotEditable()
  func unselectConcepts()

  func drawConceptViews()
  func drawConceptView(_ concept: Concept)
  func clickOnConceptView(_ conceptView: ConceptView, point: NSPoint, multipleSelect: Bool)
  func updateLinkViewsFor(_ concept: Concept)
  func conceptLinksFor(_ concept: Concept) -> [Link]
  func isConceptSaved(_ concept: Concept) -> Bool
  func removeSelectedConceptViews()
}

protocol CanvasLinkActions {
  func showConstructionArrow()
  func removeConstructionArrow()

  func drawLinkViews()
  func drawLinkView(_ link: Link)

  func selectTargetConceptView(_ point: NSPoint, fromConcept originConcept: Concept) -> ConceptView?
  func createLinkBetweenConceptsViews(_ originConceptView: ConceptView, targetConceptView: ConceptView)
  func removeLinkView(_ linkView: LinkView)
  func unselectLinks()
}

protocol BasicCanvas {
  var newConcept: Concept? { get }
  var newConceptView: ConceptView? { get }

  var concepts: [Concept] { get }
  var conceptViews: [String: ConceptView] { get set }

  var links: [Link] { get }
  var linkViews: [String: LinkView] { get set }

  func saveConcept(_ concept: ConceptView)

  func pointInCanvasCoordinates(_ point: NSPoint) -> NSPoint
  func conceptViewFor(_ concept: Concept) -> ConceptView
  func linkViewFor(_ link: Link) -> LinkView
}

// Protocol compositions

typealias Canvas = BasicCanvas & ClickableView & CanvasConceptsActions & CanvasLinkActions

// MARK: LinkView

protocol ArrowDrawable {
  func constructArrow() -> Arrow?
  func drawArrow()
  func drawArrowBorder()
}

protocol LinkViewActions {
  func selectLink()
}

protocol HoveringView {
  var isHoveringView: Bool { get set }
}

extension HoveringView where Self: NSView {
  var hoverDebug: Bool { return true }

  var hoverTrackingArea: NSTrackingArea {
    return NSTrackingArea(
      rect: bounds,
      options: [.mouseEnteredAndExited, .activeInKeyWindow],
      owner: self,
      userInfo: nil
    )
  }

  func drawHoveringState() {
//    if (isHoveringView) {
//      NSColor.blueColor().set()
//      NSBezierPath(rect: bounds).stroke()
//    }
  }

  func enableTrackingArea() {
    if (hoverDebug) {
      addTrackingArea(hoverTrackingArea)
    }
  }
}

extension NSView {
  func sprint(_ message: String) {
    Swift.print("\(description): \(message)")
  }
}
