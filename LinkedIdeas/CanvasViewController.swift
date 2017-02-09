//
//  CanvasViewController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol GraphConcept {
  var rect: NSRect { get }
  var attributedStringValue: NSAttributedString { get }
  var isSelected: Bool { get set }
}

protocol GraphLink {
  var color: NSColor { get }
  var isSelected: Bool { get set }
  
  var stringValue: String { get }
  var attributedStringValue: NSAttributedString { get }
  
  var point: NSPoint { get }
  
  var originPoint: NSPoint { get }
  var targetPoint: NSPoint { get }
  
  var originRect: NSRect { get }
  var targetRect: NSRect { get }
}

extension Concept: GraphConcept {}

extension Link: GraphLink {
  var originRect: NSRect { return origin.rect }
  var targetRect: NSRect { return target.rect }
}

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
    guard concept.isSelected else { return }
    
    NSColor.red.set()
    NSBezierPath(rect: concept.rect).stroke()
  }
}

struct DrawableLink: DrawableElement {
  let link: GraphLink
  
  func draw() {
    link.color.set()
    constructArrow()?.bezierPath().fill()
    drawSelectedRing()
    drawLinkText()
  }
  
  func drawLinkText() {
    guard link.stringValue != "" else { return }
    
    // background
    NSColor.white.set()
    var textSize = link.attributedStringValue.size()
    let padding: CGFloat = 8.0
    textSize.width += padding
    textSize.height += padding
    
    let textRect = NSRect(center: link.point, size: textSize)
    NSRectFill(textRect)
//    NSColor.blue.set()
//    NSBezierPath(rect: textRect).stroke()
    
    // text
    let bottomLeftTextPoint = link.point.translate(deltaX: -(textSize.width - padding) / 2.0, deltaY: -(textSize.height - padding) / 2.0)
    let attributedStringValue = NSAttributedString(
      attributedString: link.attributedStringValue,
      fontColor: NSColor.gray
    )
    attributedStringValue.draw(at: bottomLeftTextPoint)
  }
  
  func drawSelectedRing() {
    guard link.isSelected else { return }
    
    NSColor.red.set()
    constructArrow()?.bezierPath().stroke()
  }
  
  func constructArrow() -> Arrow? {
    let originPoint = link.originPoint
    let targetPoint = link.targetPoint
    
    if let intersectionPointWithOrigin = link.originRect.firstIntersectionTo(targetPoint),
       let intersectionPointWithTarget = link.targetRect.firstIntersectionTo(originPoint) {
      return Arrow(p1: intersectionPointWithOrigin, p2: intersectionPointWithTarget)
    } else {
      return nil
    }
  }
}

extension NSResponder {
  var identifierString: String {
    return "\(type(of: self))"
  }
  
  func print(_ message: String) {
    Swift.print("\(identifierString): \(message)")
  }
}

extension NSEvent {
  func isSingleClick() -> Bool { return clickCount == 1 }
  func isDoubleClick() -> Bool { return clickCount == 2 }
}

class CanvasViewController: NSViewController {
  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var scrollView: NSScrollView!
  
  var dragCount: Int = 0
  
  var didDragStart = false
  // to register the beginning of the drag
  // for undo purposes
  var dragStartPoint: NSPoint? = nil
  
  var stateManager = StateManager(initialState: .canvasWaiting)
  var currentState: CanvasState {
    get {
      return stateManager.currentState
    }
    set(newState) {
      stateManager.currentState = newState
    }
  }
  
  lazy var textField: NSTextField = {
    let textField = NSTextField()
    textField.isHidden = true
    textField.isEditable = false
    return textField
  }()
  
  var document: LinkedIdeasDocument! {
    didSet {
      print("- didSetDocument \(document)")
      document.observer = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("-viewDidLoad")
    canvasView.dataSource = self
    
    // modify canvas frame (size)
    // and scroll to center of it
    canvasView.frame = NSMakeRect(0, 0, 3000, 2000)
    let canvasViewCenterForScroll = NSMakePoint(
      (canvasView.frame.center.x - scrollView.frame.center.x),
      (canvasView.frame.center.y - scrollView.frame.center.y)
    )
    scrollView.scroll(canvasViewCenterForScroll)
    
    textField.delegate = self
    canvasView.addSubview(textField)
    
    stateManager.delegate = self
  }
  
  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    print("-prepareForSegue")
  }
  
  func convertToCanvasCoordinates(point: NSPoint) -> NSPoint {
    return canvasView.convert(point, from: nil)
  }
  
  func clickedSingleConcept(atPoint clickedPoint: NSPoint) -> Concept? {
    if let concepts = clickedConcepts(atPoint: clickedPoint), concepts.count == 1 {
      return concepts.first
    }
    
    return nil
  }
  
  func clickedSingleElement(atPoint clickedPoint: NSPoint) -> Element? {
    if let elements = clickedElements(atPoint: clickedPoint), elements.count == 1 {
      return elements.first
    }
    
    return nil
  }
  
  func clickedConcepts(atPoint clickedPoint: NSPoint) -> [Concept]? {
    let results = document.concepts.filter { (concept) -> Bool in
      return concept.rect.contains(clickedPoint)
    }
    guard results.count > 0 else { return nil }
    return results
  }
  
  func clickedElements(atPoint clickedPoint: NSPoint) -> [Element]? {
    var results = [Element]()
    let clickedConcepts: [Element] = document.concepts.filter { (concept) -> Bool in
      return concept.rect.contains(clickedPoint)
    }
    let clickedLinks: [Element] = document.links.filter { (link) -> Bool in
      // TODO: improve area where link is clicked
      return link.rect.contains(clickedPoint)
    }
    
    results.append(contentsOf: clickedConcepts)
    results.append(contentsOf: clickedLinks)
    
    guard results.count > 0 else { return nil }
    return results
  }
  
  /// matchedConcepts: custom description
  ///
  /// - Parameter rect: the area to match
  /// - Returns:
  ///   - nil if there were no concepts intersecting the given area
  ///   - [Concept] if there were concepts intersecting the given area
  func matchedConcepts(inRect rect: NSRect) -> [Concept]? {
    let results = document.concepts.filter { (concept) -> Bool in
      return rect.intersects(concept.rect)
    }
    guard results.count > 0 else { return nil }
    return results
  }
  
  func safeTransiton(transitionCall: () throws -> Void) {
    do {
      try transitionCall()
    } catch let error {
      Swift.print(error)
    }
  }
  
  func reRenderCanvasView() {
    canvasView.needsDisplay = true
  }
}

// MARK: - MouseEvents

extension CanvasViewController {
  override func mouseDown(with event: NSEvent) {
    Swift.print("\n")
    Swift.print("[mouseDown]")
    let point = convertToCanvasCoordinates(point: event.locationInWindow)
    
    if event.isSingleClick() {
      if let clickedElements = clickedElements(atPoint: point) {
        Swift.print("[mouseDown][singleClick] clicked concepts [\(clickedConcepts)]")
        
        if (!currentState.isSimilar(to: .multipleSelectedElements(elements: [Element]()))) {
          safeTransiton {
            try stateManager.toSelectedElement(element: clickedElements.first!)
          }
        }
        
        
      } else {
        Swift.print("[mouseDown][singleClick] no clicked concepts")
        
        safeTransiton {
          try stateManager.toCanvasWaiting()
        }
        
      }
    } else if event.isDoubleClick() {
      if let element = clickedSingleElement(atPoint: point) {
        if !element.isEditable {
          safeTransiton { try stateManager.toEditingElement(element: element) }
        } else {
          safeTransiton { try stateManager.toSelectedElement(element: element) }
        }
      } else {
        safeTransiton { try stateManager.toNewConcept(atPoint: point) }
      }
    }
  }
  
  override func mouseDragged(with event: NSEvent) {
    if (dragCount <= 3) {
      Swift.print("[mouseDragged]")
      dragCount += 1
    }
    
    let point = convertToCanvasCoordinates(point: event.locationInWindow)
    
    // Decision: which actions to trigger
    // given the context and events that happen
    
    switch currentState {
    case .selectedElement(let element):
      if (event.modifierFlags.contains(.shift)) {
        guard let concept = element as? Concept else { return }
        creationArrowForLink(toPoint: point)
        if let hoveredConcepts = clickedConcepts(atPoint: point) {
          select(elements: hoveredConcepts)
        } else {
          unselect(elements: document.concepts.filter { $0 != concept })
        }
      } else {
        guard let concept = element as? Concept else { return }
        drag(concept: concept, toPoint: point)
      }
      
    case .multipleSelectedElements(let elements):
      guard let concepts = elements as? [Concept] else { return }
      drag(concepts: concepts, toPoint: point)
      
    case .canvasWaiting:
      hoverConcepts(toPoint: point)
      
    default:
      return
    }
    
    reRenderCanvasView()
  }
  
  override func mouseUp(with event: NSEvent) {
    dragCount = 0
    Swift.print("[mouseUp] (state = \(currentState))")
    let point = convertToCanvasCoordinates(point: event.locationInWindow)
    
    switch currentState {
    case .selectedElement(let element):
      guard let concept = element as? Concept, didDragStart else {
        return
      }
      
      if (event.modifierFlags.contains(.shift)) {
        if let targetConcept = clickedSingleConcept(atPoint: point) {
          Swift.print("[mouseUp][shiftClick] (targetConcept = \(targetConcept))")
          targetConcept.isSelected = false
          safeTransiton {
            try stateManager.toNewLink(fromConcept: concept, toConcept: targetConcept)
          }
        } else {
          Swift.print("[mouseUp][shiftClick] no targetConcept!")
          safeTransiton { try stateManager.toCanvasWaiting() }
        }
      } else {
        Swift.print("[mouseUp][noShift] normal drag")
        endDrag(forConcept: concept, toPoint: point)
      }
    case .multipleSelectedElements(let elements):
      guard let concepts = elements as? [Concept] else { return }
      endDrag(forConcepts: concepts, toPoint: point)
      
    case .canvasWaiting:
      selectHoveredConcepts()
      
    default:
      return
    }
    
    Swift.print("\n")
    resetDraggingConcepts()
  }
}

// MARK: - CanvasViewDataSource

extension CanvasViewController: CanvasViewDataSource {
  var drawableElements: [DrawableElement] {
    var elements: [DrawableElement] = []
    
    elements += document.concepts.map {
      DrawableConcept(concept: $0 as GraphConcept) as DrawableElement
    }
    
    elements += document.links.map {
      DrawableLink(link: $0 as GraphLink) as DrawableElement
    }
    
    return elements
  }
}

// MARK: - DocumentObserver

extension CanvasViewController: DocumentObserver {
  func documentChanged(withElement element: Element) {
    reRenderCanvasView()
  }
}

// MARK: - StateManagerDelegate

extension CanvasViewController: StateManagerDelegate {
  func transitionSuccesfull() {
    reRenderCanvasView()
  }
  
  func transitionedToNewConcept(fromState: CanvasState) {
    guard case .newConcept(let point) = currentState else { return }
    
    commonTransitionBehavior(fromState)
    
    showTextField(atPoint: point)
  }
  
  func transitionedToCanvasWaiting(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
  }
  
  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: NSPoint, text: NSAttributedString) {
    dismissTextField()
    let _ = saveConcept(text: text, atPoint: point)
  }
  
  func transitionedToSelectedElement(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
    
    guard case .selectedElement(let element) = currentState else { return }
    
    select(elements: [element])
  }
  
  func transitionedToMultipleSelectedElements(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
    
    guard case .multipleSelectedElements(let elements) = currentState else { return }
    
    select(elements: elements)
  }
  
  func transitionedToSelectedElementSavingChanges(fromState: CanvasState) {
    guard case .selectedElement(var element) = currentState else { return }
    element.attributedStringValue = textField.attributedStringValue
    dismissTextField()
    
    transitionedToSelectedElement(fromState: fromState)
  }
  
  func transitionedToEditingElement(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
    
    guard case .editingElement(var element) = currentState else { return }
    
    element.isEditable = true
    
    showTextField(atPoint: element.point, text: element.attributedStringValue)
  }
  
  func transitionedToNewLink(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
    
    guard case .newLink(let fromConcept, let toConcept) = currentState else { return }
    
    // show canvas view link construction arrow in another color
    // TODO: this part can be a function
    let originPoint = fromConcept.point
    let targetPoint = toConcept.point
    
    if let intersectionPointWithOrigin = fromConcept.rect.firstIntersectionTo(targetPoint),
      let intersectionPointWithTarget = toConcept.rect.firstIntersectionTo(originPoint) {
      
      canvasView.arrowStartPoint = intersectionPointWithOrigin
      canvasView.arrowEndPoint = intersectionPointWithTarget
      canvasView.arrowColor = NSColor.blue
      reRenderCanvasView()
    }
    
    // show text field in the middle of the concepts
    let middlePointBetweenConcepts = NSMakePoint(
      ((fromConcept.point.x + toConcept.point.x) / 2.0),
      ((fromConcept.point.y + toConcept.point.y) / 2.0)
    )
    showTextField(atPoint: middlePointBetweenConcepts, text: NSAttributedString(string: ""))
  }
  
  func transitionedToCanvasWaitingSavingLink(fromState: CanvasState, fromConcept: Concept, toConcept: Concept, text: NSAttributedString) {
    dismissTextField()
    dismissConstructionArrow()
    let _ = saveLink(fromConcept: fromConcept, toConcept: toConcept, text: text)
  }
  
  private func commonTransitionBehavior(_ fromState: CanvasState) {
    switch fromState {
    case .newConcept:
      dismissTextField()
    case .editingElement(var element):
      element.isEditable = false
      dismissTextField()
    case .selectedElement(let element):
      unselect(elements: [element])
      dismissConstructionArrow()
    case .multipleSelectedElements(let elements):
      unselect(elements: elements)
    case .newLink:
      cancelLinkCreation()
    default:
      break
    }
  }
}

// MARK: - Transition Actions

extension CanvasViewController {
  func select(elements: [Element]) {
    for var element in elements { element.isSelected = true }
  }
  
  func unselect(elements: [Element]) {
    for var element in elements { element.isSelected = false }
  }
  
  func saveConcept(text: NSAttributedString, atPoint point: NSPoint) -> Bool {
    guard text.string != "" else { return false }
    
    let newConcept = Concept(attributedStringValue: text, point: point)
    
    document.save(concept: newConcept)
    return true
  }
  
  func saveLink(fromConcept: Concept, toConcept: Concept, text: NSAttributedString) -> Bool {
    let newLink = Link(origin: fromConcept, target: toConcept, attributedStringValue: text)
    
    document.save(link: newLink)
    
    return true
  }
  
  func showTextField(atPoint point: NSPoint, text: NSAttributedString? = nil) {
    textField.frame = NSRect(center: point, size: NSMakeSize(60, 40))
    textField.isEditable = true
    textField.isHidden = false
    if let text = text { textField.attributedStringValue = text }
    textField.becomeFirstResponder()
  }
  
  func dismissTextField() {
    textField.setFrameOrigin(NSPoint.zero)
    textField.isEditable = false
    textField.isHidden = true
    textField.stringValue = ""
    textField.resignFirstResponder()
  }
}

// MARK: - NSTextFieldDelegate

// TODO: handle escape when editing concept

extension CanvasViewController: NSTextFieldDelegate {
  // Invoked when users press keys with predefined bindings in a cell of the specified control.
  func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    switch commandSelector {
    case #selector(NSResponder.cancelOperation(_:)):
      safeTransiton {
        try stateManager.toCanvasWaiting()
      }
      return true
    case #selector(NSResponder.insertNewline(_:)):
      switch currentState {
      case .editingElement(let element):
        safeTransiton {
          try stateManager.toSelectedElementSavingChanges(element: element)
        }
      case .newConcept:
        safeTransiton {
          try stateManager.toCanvasWaiting(savingConceptWithText: control.attributedStringValue)
        }
      case .newLink:
        safeTransiton {
          try stateManager.toCanvasWaiting(savingLinkWithText: control.attributedStringValue)
        }
      default:
        Swift.print("[textField][enterKey] unhandled event (state = \(currentState))")
      }
      return true
    default:
      return false
    }
  }
}
