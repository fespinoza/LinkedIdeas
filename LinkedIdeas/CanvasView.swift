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
  func updateLinkViewsFor(concept: Concept)
  func isConceptSaved(concept: Concept) -> Bool
}

protocol CanvasLinkActions {
  func showConstructionArrow()
  func removeConstructionArrow()
  
  func drawLinkViews()
  func drawLinkView(link: Link)

  func selectTargetConceptView(point: NSPoint, fromConcept originConcept: Concept) -> ConceptView?
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
  func conceptViewFor(concept: Concept) -> ConceptView
  func linkViewFor(link: Link) -> LinkView
}

// Protocol compositions

typealias Canvas = protocol<BasicCanvas, ClickableView, CanvasConceptsActions, CanvasLinkActions>

class CanvasView: NSView, Canvas {
  var newConcept: Concept? = nil
  var newConceptView: ConceptView? = nil
  var concepts: [Concept] = [Concept]()
  var conceptViews: [String: ConceptView] = [String: ConceptView]()
  var mode: Mode = .Select
  var links: [Link] = [Link]()
  var linkViews: [String: LinkView] = [String: LinkView]()

  // MARK: - NSView
  
  override func drawRect(dirtyRect: NSRect) {
    NSColor.whiteColor().set()
    NSRectFill(bounds)
    drawConceptViews()
    drawLinkViews()
    
    if (mode == .Links) { showConstructionArrow() }
  }

  // MARK: - MouseEvents
  
  override func mouseDown(theEvent: NSEvent) {
    let clickedPoint = pointInCanvasCoordinates(theEvent.locationInWindow)
    if (theEvent.clickCount == 2) {
      doubleClick(clickedPoint)
    } else {
      click(clickedPoint)
    }
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
  
  func conceptViewFor(concept: Concept) -> ConceptView {
    return conceptViews[concept.identifier]!
  }
  
  func linkViewFor(link: Link) -> LinkView {
    return linkViews[link.identifier]!
  }
  
  // MARK: - ClickableView
  
  func click(point: NSPoint) {
    if mode == .Concepts { createConceptAt(point) }
    doubleClick(point)
  }
  
  func doubleClick(point: NSPoint) {
    markConceptsAsNotEditable()
    unselectConcepts()
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
    sprint("click on conceptView \(conceptView.concept.identifier) to \(point)")
    let selectedConcept = conceptView.concept
    for concept in concepts {
      if (concept.identifier != selectedConcept.identifier) {
        concept.isSelected = false
        concept.isEditable = false
        conceptViewFor(concept).needsDisplay = true
      }
    }
    cleanNewConcept()
  }
  
  var arrowOriginPoint: NSPoint?
  var arrowTargetPoint: NSPoint?
  
  func dragFromConceptView(conceptView: ConceptView, point: NSPoint) {
    sprint("drag from conceptView \(conceptView.concept.identifier) to \(point)")
    arrowOriginPoint = conceptView.concept.point
    arrowTargetPoint = point
    updateLinkViewsFor(conceptView.concept)
    needsDisplay = true
  }
  
  func releaseMouseFromConceptView(conceptView: ConceptView, point: NSPoint) {
    if let targetedConceptView = selectTargetConceptView(point, fromConcept: conceptView.concept) {
      createLinkBetweenConceptsViews(conceptView, targetConceptView: targetedConceptView)
    }
    
    removeConstructionArrow()
  }

  func cleanNewConcept() {
    newConceptView?.removeFromSuperview()
    newConceptView = nil
    newConcept = nil
  }
  
  func updateLinkViewsFor(concept: Concept) {
    let conceptLinks = links.filter {
      return $0.origin.identifier == concept.identifier || $0.target.identifier == concept.identifier
    }
    for link in conceptLinks { linkViewFor(link).frame = link.minimalRect }
  }
  
  func isConceptSaved(concept: Concept) -> Bool {
    return concept != newConcept
  }
  
  // MARK: - CanvasLinkActions
  
  func drawLinkViews() {
    for link in links { drawLinkView(link) }
  }
  
  func drawLinkView(link: Link) {
    if let linkView = linkViews[link.identifier] {
      linkView.needsDisplay = true
    } else {
      sprint("draw new link view for \(link)")
      let linkView = LinkView(link: link, canvas: self)
      addSubview(linkView)
      linkViews[link.identifier] = linkView
    }
  }
  
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
  
  func selectTargetConceptView(point: NSPoint, fromConcept originConcept: Concept) -> ConceptView? {
    for (_, conceptView) in conceptViews {
      if (mode == .Links && conceptView.concept != originConcept && CGRectContainsPoint(conceptView.frame, point)) {
        return conceptView
      }
    }

    return nil
  }
  
  func createLinkBetweenConceptsViews(originConceptView: ConceptView, targetConceptView: ConceptView) {
    let link = Link(origin: originConceptView.concept, target: targetConceptView.concept)
    links.append(link)
    
    sprint("create link \(link)")
    
    drawLinkView(link)
  }
  
  // MARK: - Debugging
  func sprint(message: String) {
    Swift.print("[CanvasView]: \(message)")
  }
}
