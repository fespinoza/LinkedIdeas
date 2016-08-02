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

  override func draw(_ dirtyRect: NSRect) {
    NSColor.white.set()
    NSRectFill(bounds)
    drawConceptViews()
    drawLinkViews()

    if isDragging {
      if let initialPoint = initialPoint, let endPoint = endPoint {
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

  func containingRectFor(_ elements: [SquareElement]) -> NSRect {
    if (elements.isEmpty) {
      return NSMakeRect(0, 0, 900, 530)
    }

    let minX = (elements.map { $0.rect.origin.x }).min()!
    let minY = (elements.map { $0.rect.origin.y }).min()!
    let maxX = (elements.map { $0.rect.maxX }).max()!
    let maxY = (elements.map { $0.rect.maxY }).max()!
    return NSMakeRect(minX, minY, maxX - minX, maxY - minY)
  }

  let minCanvasSize = NSMakeSize(900, 530)
  let padding: CGFloat = 300.0

  override var intrinsicContentSize: NSSize {
    var elements = [SquareElement]()
    if document != nil {
      elements = concepts.map { $0 as SquareElement }
    }
    var size = containingRectFor(elements).size
    size.height = [size.height, minCanvasSize.height].max()! + padding
    size.width  = [size.width, minCanvasSize.width].max()! + padding
    return size
  }

  // MARK: - MouseEvents

  override func mouseDown(with theEvent: NSEvent) {
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

  override func mouseDragged(with theEvent: NSEvent) {
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

  override func mouseUp(with theEvent: NSEvent) {
    if (mode == .Select) {
      isDragging = false
      needsDisplay = true
    }
    (window?.windowController as? WindowController)?.selectedElementsCallback()
  }
  
  // MARK: - Keyboard Events
  let deleteKeyCode: UInt16 = 51
  override func keyDown(with theEvent: NSEvent) {
    if (theEvent.keyCode == deleteKeyCode) {
      removeSelectedConceptViews()
    } else {
      super.keyDown(with: theEvent)
    }
  }

  // MARK: - BasicCanvas

  func saveConcept(_ concept: ConceptView) {
    let _newConcept = concept.concept
    justSaveConcept(_newConcept)
  }
  
  func justSaveConcept(_ concept: Concept) {
    resetNewConcept()
    document.saveConcept(concept)
  }
  
  func resetNewConcept() {
    newConcept = nil
    newConceptView?.removeFromSuperview()
    newConceptView = nil
  }

  func pointInCanvasCoordinates(_ point: NSPoint) -> NSPoint {
    return convert(point, from: nil)
  }

  func conceptViewFor(_ concept: Concept) -> ConceptView {
    return conceptViews[concept.identifier]!
  }

  func linkViewFor(_ link: Link) -> LinkView {
    return linkViews[link.identifier]!
  }

  // MARK: - ClickableView

  func click(_ point: NSPoint) {
    if mode == .Concepts { createConceptAt(point) }
    doubleClick(point)
  }

  func doubleClick(_ point: NSPoint) {
    markConceptsAsNotEditable()
    unselectConcepts()
    unselectLinks()
    becomeFirstResponder()
  }

  // MARK: - CanvasConceptsActions

  func drawConceptViews() {
    for concept in concepts { drawConceptView(concept) }
  }

  func drawConceptView(_ concept: Concept) {
    if let conceptView = conceptViews[concept.identifier] {
      conceptView.needsDisplay = true
    } else {
      createConceptViewFor(concept)
    }
  }

  func deselectConcepts() {}
  func removeNonSavedConcepts() {}

  func createConceptAt(_ point: NSPoint) {
    let _newConcept = Concept(point: point)
    _newConcept.isEditable = true
    let _newConceptView = createConceptViewFor(_newConcept)

    newConceptView?.removeFromSuperview()

    newConcept = _newConcept
    newConceptView = _newConceptView
  }
  
  func isRunningInTestMode() -> Bool {
    return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
  }

  func createConceptViewFor(_ concept: Concept) -> ConceptView {
    let conceptView = ConceptView(concept: concept, canvas: self)
    conceptViews[concept.identifier] = conceptView
    
    if isRunningInTestMode() {
      addSubview(conceptView, positioned:.above, relativeTo: nil)
    } else {
      DispatchQueue.main.async(execute: { [unowned self] in
        self.addSubview(conceptView, positioned:.above, relativeTo: nil)
      })
    }
    
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

  func clickOnConceptView(_ conceptView: ConceptView, point: NSPoint, multipleSelect: Bool = false) {
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

  func updateLinkViewsFor(_ concept: Concept) {
    for link in conceptLinksFor(concept) {
      linkViewFor(link).frame = link.rect
    }
  }

  func isConceptSaved(_ concept: Concept) -> Bool {
    return concept != newConcept
  }

  func justRemoveConceptView(_ conceptView: ConceptView) {
    let concept = conceptView.concept
    conceptViews.removeValue(forKey: concept.identifier)
    conceptView.isHidden = true
    conceptView.removeFromSuperview()

    for link in conceptLinksFor(concept) { removeLinkView(linkViewFor(link)) }
  }

  func removeSelectedConceptViews() {
    for concept in selectedConcepts() {
      let currentConceptView = conceptViewFor(concept)
      document.removeConcept(concept)
      justRemoveConceptView(currentConceptView)
    }
  }

  func conceptLinksFor(_ concept: Concept) -> [Link] {
    return links.filter {
      return $0.origin.identifier == concept.identifier ||
        $0.target.identifier == concept.identifier
    }
  }

  // MARK: - CanvasLinkActions

  func drawLinkViews() {
    for link in links { drawLinkView(link) }
  }

  func drawLinkView(_ link: Link) {
    if let linkView = linkViews[link.identifier] {
      linkView.needsDisplay = true
    } else {
      let linkView = LinkView(link: link, canvas: self)
      addSubview(linkView, positioned: .below, relativeTo: nil)
      linkViews[link.identifier] = linkView
    }
  }

  func showConstructionArrow() {
    if let arrowOriginPoint = arrowOriginPoint, let arrowTargetPoint = arrowTargetPoint {
      NSColor.blue.set()
      let arrow = Arrow(p1: arrowOriginPoint, p2: arrowTargetPoint)
      arrow.bezierPath().fill()
    }
  }

  func removeConstructionArrow() {
    arrowOriginPoint = nil
    arrowTargetPoint = nil
  }

  func selectTargetConceptView(_ point: NSPoint, fromConcept originConcept: Concept) -> ConceptView? {
    for (_, conceptView) in conceptViews {
      if (mode == .Links && conceptView.concept != originConcept && conceptView.frame.contains(point)) {
        return conceptView
      }
    }

    return nil
  }

  func createLinkBetweenConceptsViews(_ originConceptView: ConceptView, targetConceptView: ConceptView) {
    let link = Link(origin: originConceptView.concept, target: targetConceptView.concept)

    if let windowController = window?.windowController as? WindowController {
      link.color = windowController.selectedColor
    }

    document.saveLink(link)
  }

  func removeLinkView(_ linkView: LinkView) {
    let link = linkView.link
    document.removeLink(link)
    justRemoveLinkView(linkView)
  }

  func justRemoveLinkView(_ linkView: LinkView) {
    linkViews.removeValue(forKey: linkView.link.identifier)
    linkView.removeFromSuperview()
  }

  func unselectLinks() {
    for link in links { link.isSelected = false }
    drawLinkViews()
  }

  // MARK: - DocumentObserver
  func conceptAdded(_ concept: Concept) {
    createConceptViewFor(concept)
  }

  func conceptRemoved(_ concept: Concept) {
    justRemoveConceptView(conceptViewFor(concept))
  }

  func conceptUpdated(_ concept: Concept) {
    let conceptView = conceptViewFor(concept)
    conceptView.updateFrameToMatchConcept()
    conceptView.needsDisplay = true
    updateLinkViewsFor(concept)
  }

  func linkAdded(_ link: Link) {
    drawLinkView(link)
  }

  func linkRemoved(_ link: Link) {
    justRemoveLinkView(linkViewFor(link))
  }

  func linkUpdated(_ link: Link) {
    let linkView = linkViewFor(link)
    linkView.needsDisplay = true
  }

  // MARK: - DraggableElementDelegate
  func dragStartCallback(_ draggableElementView: DraggableElement, dragEvent: DragEvent) {
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

  func dragToCallback(_ draggableElementView: DraggableElement, dragEvent: DragEvent) {
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

  func dragEndCallback(_ draggableElementView: DraggableElement, dragEvent: DragEvent) {
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
