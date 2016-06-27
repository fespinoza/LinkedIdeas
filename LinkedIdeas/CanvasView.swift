//
//  CanvasView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class CanvasView: NSView, Canvas, DocumentObserver, DraggableElementDelegate {
  var document: LinkedIdeasDocument! {
    didSet { document.observer = self }
  }

  var newConcept: Concept? = nil
  var newConceptView: ConceptView? = nil

  var conceptViews: [String: ConceptView] = [String: ConceptView]()
  var linkViews: [String: LinkView] = [String: LinkView]()

  var concepts: [Concept] { return document.concepts }
  var links: [Link] { return document.links }

  var mode: Mode = .Select

  // MARK: - NSResponder
  override var acceptsFirstResponder: Bool { return true }

  override var description: String {
    return "[CanvasView]"
  }

  // MARK: - NSView
  let fillColor = NSColor(calibratedRed: 173/255, green: 224/255, blue: 186/255, alpha: 1)
  let borderColor = NSColor(calibratedRed: 144/255, green: 212/255, blue: 161/255, alpha: 1)

  override func drawRect(dirtyRect: NSRect) {
    NSColor.whiteColor().set()
    NSRectFill(bounds)
    drawConceptViews()
    drawLinkViews()

    if isDragging {
      if let initialPoint = initialPoint, endPoint = endPoint {
        let selectionRect = NSRect(p1: initialPoint, p2: endPoint)
        let path = NSBezierPath(rect: selectionRect)
        fillColor.set()
        path.fill()
        borderColor.set()
        path.stroke()
      }
    }

    if (mode == .Links) { showConstructionArrow() }
  }

  func containingRectFor(elements: [SquareElement]) -> NSRect {
    if (elements.isEmpty) {
      return NSMakeRect(0, 0, 900, 530)
    }

    let minX = (elements.map { $0.rect.origin.x }).minElement()!
    let minY = (elements.map { $0.rect.origin.y }).minElement()!
    let maxX = (elements.map { $0.rect.maxX }).maxElement()!
    let maxY = (elements.map { $0.rect.maxY }).maxElement()!
    return NSMakeRect(minX, minY, maxX - minX, maxY - minY)
  }

  let minCanvasSize = NSMakeSize(900, 530)
  let padding: CGFloat = 300.0

  override var intrinsicContentSize: NSSize {
    let elements = concepts.map { $0 as SquareElement }
    var size = containingRectFor(elements).size
    size.height = [size.height, minCanvasSize.height].maxElement()! + padding
    size.width  = [size.width, minCanvasSize.width].maxElement()! + padding
    return size
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

  var isDragging: Bool = false
  var initialPoint: NSPoint?
  var endPoint: NSPoint?

  override func mouseDragged(theEvent: NSEvent) {
    if (mode == .Select) {
      let point = pointInCanvasCoordinates(theEvent.locationInWindow)
      if isDragging {
        // already dragging
        endPoint = point
        let selectionRect = NSRect(p1: initialPoint!, p2: endPoint!)
        for concept in concepts {
          concept.isSelected = selectionRect.contains(concept.point)
          conceptViewFor(concept).needsDisplay = true
        }
        needsDisplay = true
      } else {
        // first dragging
        isDragging = true
        initialPoint = point
      }
    }
  }

  override func mouseUp(theEvent: NSEvent) {
    if (mode == .Select) {
      isDragging = false
      needsDisplay = true
    }
  }

  // MARK: - BasicCanvas

  func saveConcept(concept: ConceptView) {
    let _newConcept = concept.concept
    newConcept = nil
    newConceptView?.removeFromSuperview()
    newConceptView = nil
    document.saveConcept(_newConcept)
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
    unselectLinks()
    becomeFirstResponder()
  }

  // MARK: - CanvasConceptsActions

  func drawConceptViews() {
    for concept in concepts { drawConceptView(concept) }
  }

  func drawConceptView(concept: Concept) {
    if let conceptView = conceptViews[concept.identifier] {
      conceptView.needsDisplay = true
    } else {
      createConceptViewFor(concept)
    }
  }

  func deselectConcepts() {}
  func removeNonSavedConcepts() {}

  func createConceptAt(point: NSPoint) {
    let _newConcept = Concept(point: point)
    _newConcept.isEditable = true
    let _newConceptView = createConceptViewFor(_newConcept)

    newConceptView?.removeFromSuperview()

    newConcept = _newConcept
    newConceptView = _newConceptView

  }

  func createConceptViewFor(concept: Concept) -> ConceptView {
    let conceptView = ConceptView(concept: concept, canvas: self)
    conceptViews[concept.identifier] = conceptView

    dispatch_async(dispatch_get_main_queue(), { [unowned self] in
      self.addSubview(conceptView, positioned:.Above, relativeTo: nil)
    })

    return conceptView
  }

  func markConceptsAsNotEditable() {
    for concept in concepts { concept.isEditable = false }
    drawConceptViews()
  }

  func unselectConcepts() {
    for concept in concepts { concept.isSelected = false }
    drawConceptViews()
  }

  func clickOnConceptView(conceptView: ConceptView, point: NSPoint, multipleSelect: Bool = false) {
    let clickedConcept = conceptView.concept
    let selectedConcepts = concepts.filter { $0.isSelected }

    let notAddingConceptsToMultipleSelect = !multipleSelect
    let clickedConceptIsNotPartOfMultipleSelection = !selectedConcepts.contains(clickedConcept)

    for concept in concepts {
      if (concept.identifier != clickedConcept.identifier) {
        if notAddingConceptsToMultipleSelect && clickedConceptIsNotPartOfMultipleSelection {
          concept.isSelected = false
        }
        concept.isEditable = false
        conceptViewFor(concept).needsDisplay = true
      }
    }
    cleanNewConcept()
  }

  func selectedConcepts() -> [Concept] {
    return concepts.filter { $0.isSelected }
  }

  func cleanNewConcept() {
    newConceptView?.removeFromSuperview()
    newConceptView = nil
    newConcept = nil
  }

  func updateLinkViewsFor(concept: Concept) {
    for link in conceptLinksFor(concept) {
      linkViewFor(link).frame = link.rect
    }
  }

  func isConceptSaved(concept: Concept) -> Bool {
    return concept != newConcept
  }

  func justRemoveConceptView(conceptView: ConceptView) {
    let concept = conceptView.concept
    conceptViews.removeValueForKey(concept.identifier)
    conceptView.hidden = true
    conceptView.removeFromSuperview()

    for link in conceptLinksFor(concept) { removeLinkView(linkViewFor(link)) }
  }

  func removeConceptView(conceptView: ConceptView) {
    let concept = conceptView.concept
    document.removeConcept(concept)
    justRemoveConceptView(conceptView)
  }

  func conceptLinksFor(concept: Concept) -> [Link] {
    return links.filter {
      return $0.origin.identifier == concept.identifier ||
        $0.target.identifier == concept.identifier
    }
  }

  // MARK: - CanvasLinkActions

  func drawLinkViews() {
    for link in links { drawLinkView(link) }
  }

  func drawLinkView(link: Link) {
    if let linkView = linkViews[link.identifier] {
      linkView.needsDisplay = true
    } else {
      let linkView = LinkView(link: link, canvas: self)
      addSubview(linkView, positioned: .Below, relativeTo: nil)
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

    if let windowController = window?.windowController as? WindowController {
      link.color = windowController.selectedColor
    }

    document.saveLink(link)
  }

  func removeLinkView(linkView: LinkView) {
    let link = linkView.link
    document.removeLink(link)
    justRemoveLinkView(linkView)
  }

  func justRemoveLinkView(linkView: LinkView) {
    linkViews.removeValueForKey(linkView.link.identifier)
    linkView.removeFromSuperview()
  }

  func unselectLinks() {
    for link in links { link.isSelected = false }
    drawLinkViews()
  }

  // MARK: - DocumentObserver
  func conceptAdded(concept: Concept) {
    createConceptViewFor(concept)
  }

  func conceptRemoved(concept: Concept) {
    justRemoveConceptView(conceptViewFor(concept))
  }

  func conceptUpdated(concept: Concept) {
    let conceptView = conceptViewFor(concept)
    conceptView.updateFrameToMatchConcept()
    conceptView.needsDisplay = true
    updateLinkViewsFor(concept)
  }

  func linkAdded(link: Link) {
    drawLinkView(link)
  }

  func linkRemoved(link: Link) {
    justRemoveLinkView(linkViewFor(link))
  }

  func linkUpdated(link: Link) {
    let linkView = linkViewFor(link)
    linkView.needsDisplay = true
  }

  // MARK: - DraggableElementDelegate
  func dragStartCallback(draggableElementView: DraggableElement, dragEvent: DragEvent) {
    let conceptView = draggableElementView as! ConceptView

    if (mode == .Select) {
      for concept in selectedConcepts() where concept != conceptView.concept {
        let newPoint = dragEvent.translatePoint(concept.point)
        conceptViewFor(concept).dragStart(newPoint, performCallback: false)
      }
    }

    if (mode == .Links) {
      arrowOriginPoint = conceptView.concept.point
    }
  }

  func dragToCallback(draggableElementView: DraggableElement, dragEvent: DragEvent) {
    let conceptView = draggableElementView as! ConceptView

    if (mode == .Select) {
      for concept in selectedConcepts() where concept != conceptView.concept {
        let newPoint = dragEvent.translatePoint(concept.point)
        conceptViewFor(concept).dragTo(newPoint, performCallback: false)
      }
    }

    if (mode == .Links) {
      arrowTargetPoint = dragEvent.toPoint
      needsDisplay = true
    }

    updateLinkViewsFor(conceptView.concept)
  }

  var arrowOriginPoint: NSPoint?
  var arrowTargetPoint: NSPoint?

  func dragEndCallback(draggableElementView: DraggableElement, dragEvent: DragEvent) {
    let conceptView = draggableElementView as! ConceptView

    if (mode == .Select) {
      for concept in selectedConcepts() where concept != conceptView.concept {
        let newPoint = dragEvent.translatePoint(concept.point)
        conceptViewFor(concept).dragEnd(newPoint, performCallback: false)
      }
    }

    if (mode == .Links) {
      if let targetedConceptView = selectTargetConceptView(dragEvent.toPoint, fromConcept: conceptView.concept) {
        createLinkBetweenConceptsViews(conceptView, targetConceptView: targetedConceptView)
      }

      removeConstructionArrow()
    }
  }
}
