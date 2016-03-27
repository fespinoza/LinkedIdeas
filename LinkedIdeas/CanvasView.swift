//
//  CanvasView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol ClickableView {
  func click(point: NSPoint)
  func doubleClick(point: NSPoint)
}

protocol CanvasConceptsActions {
  func deselectConcepts()
  func removeNonSavedConcepts()
  func createConceptAt(point: NSPoint)
  func markConceptsAsNotEditable()
  func unselectConcepts()

  func drawConceptViews()
  func drawConceptView(concept: Concept)
  func clickOnConceptView(conceptView: ConceptView, point: NSPoint)
  func dragFromConceptView(conceptView: ConceptView, point: NSPoint)
  func releaseMouseFromConceptView(conceptView: ConceptView, point: NSPoint)
}

protocol CanvasLinkActions {
  func showConstructionArrow()
  func removeConstructionArrow()

  func selectTargetConceptView(point: NSPoint) -> ConceptView?
  func createLinkBetweenConceptsViews(originConceptView: ConceptView, targetConceptView: ConceptView)
}

protocol BasicCanvas {
  var newConcept: Concept? { get }
  var newConceptView: ConceptView? { get }

  var concepts: [Concept] { get set }
  var conceptViews: [String: ConceptView] { get set }

  func addConceptView(concept: Concept)
  func saveConcept(concept: ConceptView)
  
  func pointInCanvasCoordinates(point: NSPoint) -> NSPoint
}

// Protocol compositions

typealias Canvas = protocol<BasicCanvas, ClickableView, CanvasConceptsActions, CanvasLinkActions>

// Protocol conditional extension
extension ClickableView where Self: CanvasConceptsActions {
  func click(point: NSPoint) {
    markConceptsAsNotEditable()
    unselectConcepts()
    createConceptAt(point)
  }

  func doubleClick(point: NSPoint) {}
}

class CanvasView: NSView, Canvas {
  var newConcept: Concept? = nil
  var newConceptView: ConceptView? = nil
  var concepts: [Concept] = [Concept]()
  var conceptViews: [String: ConceptView] = [String: ConceptView]()
  var mode: Mode = Mode.Concepts
  var links: [Link] = [Link]()
  var linkViews: [String: LinkView] = [String: LinkView]()

  // MARK: - NSView
  
  override func drawRect(dirtyRect: NSRect) {
    NSColor.whiteColor().set()
    NSRectFill(bounds)
    drawConceptViews()
    
    if (mode == .Links) { showConstructionArrow() }
  }

  // MARK: - MouseEvents
  
  override func mouseDown(theEvent: NSEvent) {
    let clickedPoint = pointInCanvasCoordinates(theEvent.locationInWindow)
    click(clickedPoint)
  }

  // MARK: - BasicCanvas
  
  func addConceptView(concept: Concept) {
  }

  func saveConcept(concept: ConceptView) {
    let _newConcept = concept.concept
    let _newConceptView = concept

    newConcept = nil
    newConceptView = nil

    concepts.append(_newConcept)
    conceptViews[_newConcept.identifier] = _newConceptView
  }
  
  func pointInCanvasCoordinates(point: NSPoint) -> NSPoint {
    return convertPoint(point, fromView: nil)
  }

  // MARK: - CanvasConceptsActions
  func drawConceptViews() {
    for concept in concepts { drawConceptView(concept) }
  }

  func drawConceptView(concept: Concept) {
    if let conceptView = conceptViews[concept.identifier] {
      conceptView.needsDisplay = true
    } else {
      let conceptView = ConceptView(concept: concept, canvas: self)
      conceptViews[concept.identifier] = conceptView
      addSubview(conceptView)
    }
  }

  func deselectConcepts() {}
  func removeNonSavedConcepts() {}

  func createConceptAt(point: NSPoint) {
    let _newConcept = Concept(point: point)
    _newConcept.isEditable = true
    let _newConceptView = ConceptView(concept: _newConcept, canvas: self)

    newConceptView?.removeFromSuperview()

    newConcept = _newConcept
    newConceptView = _newConceptView
    addSubview(_newConceptView)
  }

  func markConceptsAsNotEditable() {
    for concept in concepts { concept.isEditable = false }
  }

  func unselectConcepts() {
    for concept in concepts { concept.isSelected = false }
  }

  func clickOnConceptView(conceptView: ConceptView, point: NSPoint) {
    let selectedConcept = conceptView.concept
    for concept in concepts {
      if (concept.identifier != selectedConcept.identifier) {
        concept.isSelected = false
        concept.isEditable = false
        conceptViews[concept.identifier]!.needsDisplay = true
      }
    }
    cleanNewConcept()
  }
  
  var arrowOriginPoint: NSPoint?
  var arrowTargetPoint: NSPoint?
  
  func dragFromConceptView(conceptView: ConceptView, point: NSPoint) {
    arrowOriginPoint = conceptView.concept.point
    arrowTargetPoint = point
    needsDisplay = true
  }
  
  func releaseMouseFromConceptView(conceptView: ConceptView, point: NSPoint) {
    if let targetedConceptView = selectTargetConceptView(point) {
      createLinkBetweenConceptsViews(conceptView, targetConceptView: targetedConceptView)
    }
    
    removeConstructionArrow()
  }

  func cleanNewConcept() {
    newConceptView?.removeFromSuperview()
    newConceptView = nil
    newConcept = nil
  }
  
  // MARK: - CanvasLinkActions
  
  func showConstructionArrow() {
    if let arrowOriginPoint = arrowOriginPoint, arrowTargetPoint = arrowTargetPoint {
      NSColor.blueColor().set()
      let arrow = Arrow(p1: arrowOriginPoint, p2: arrowTargetPoint)
      arrow.bezierPath().fill()
    }
  }
  
  func removeConstructionArrow() {
    arrowOriginPoint = nil
    arrowTargetPoint = nil
  }
  
  func selectTargetConceptView(point: NSPoint) -> ConceptView? {
    for (_, conceptView) in conceptViews {
      if (mode == .Links && CGRectContainsPoint(conceptView.frame, point)) {
        return conceptView
      }
    }

    return nil
  }
  
  func createLinkBetweenConceptsViews(originConceptView: ConceptView, targetConceptView: ConceptView) {
    let link = Link(origin: originConceptView.concept, target: targetConceptView.concept)
    let linkView = LinkView(link: link, canvas: self)
    
    addSubview(linkView)
    
    links.append(link)
    linkViews[link.identifier] = linkView
  }
}
