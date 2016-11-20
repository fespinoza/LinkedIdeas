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
    concept.attributedStringValue.draw(at: concept.rect.origin)
    drawSelectedRing()
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
  
  var didDragStart = false
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
  
  func clickedConcepts(atPoint clickedPoint: NSPoint) -> [Concept]? {
    let results = document.concepts.filter { (concept) -> Bool in
      return concept.rect.contains(clickedPoint)
    }
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
}

// MARK: - MouseEvents

extension CanvasViewController {
  override func mouseDown(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)
    
    if event.isSingleClick() {
      if let clickedConcepts = clickedConcepts(atPoint: point) {
        safeTransiton {
          try stateManager.toSelectedElement(element: clickedConcepts.first!)
        }
      } else {
        safeTransiton {
          try stateManager.toCanvasWaiting()
        }
      }
    } else if event.isDoubleClick() {
      if let concept = clickedSingleConcept(atPoint: point) {
        if !concept.isEditable {
          safeTransiton { try stateManager.toEditingElement(element: concept) }
        } else {
          safeTransiton { try stateManager.toSelectedElement(element: concept) }
        }
      } else {
        safeTransiton { try stateManager.toNewConcept(atPoint: point) }
      }
    }
  }
  
  override func mouseDragged(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)
    
    switch currentState {
    case .selectedElement(let element):
      // dragging a single selected concept
      guard let concept = element as? Concept else { return }
      
      if didDragStart == false { didDragStart = true }
      
      concept.point = point
      canvasView.needsDisplay = true
    case .multipleSelectedElements(let elements):
      guard let concepts = elements as? [Concept] else { return }
      
      if let oldDragStart = dragStartPoint, didDragStart {
        let deltaX = point.x - oldDragStart.x
        let deltaY = point.y - oldDragStart.y
        
        dragStartPoint = point
        
        for concept in concepts {
          concept.point = concept.point.translate(deltaX: deltaX, deltaY: deltaY)
        }
      } else {
        for concept in concepts { concept.beforeMovingPoint = concept.point }
        Swift.print("drag start at \(point)")
        didDragStart = true
        dragStartPoint = point
      }
      
      canvasView.needsDisplay = true
    case .canvasWaiting:
      // start selecting elements
      if didDragStart == false {
        didDragStart = true
        canvasView.selectFromPoint = point
      } else {
        canvasView.selectToPoint = point
      }
      canvasView.needsDisplay = true
    default:
      return
    }
  }
  
  override func mouseUp(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)
    
    switch currentState {
    case .selectedElement(let element):
      // drag end a single selected concept
      guard let concept = element as? Concept else { return }
      
      guard didDragStart else { return }
      
      Swift.print("Drag end")
      document.move(concept: concept, toPoint: point)
      
      didDragStart = false
    case .multipleSelectedElements(let elements):
      Swift.print("multiple drag ended")
      
      guard let concepts = elements as? [Concept] else { return }
      
      guard let oldDragStart = dragStartPoint, didDragStart else { return }
    
      Swift.print("Multiple Drag end")
      for concept in concepts {
        let toPoint = concept.point
        let deltaX = point.x - oldDragStart.x
        let deltaY = point.y - oldDragStart.y
        concept.point = concept.beforeMovingPoint!
        document.move(concept: concept, toPoint: toPoint.translate(deltaX: deltaX, deltaY: deltaY))
        concept.beforeMovingPoint = nil
      }
      
      dragStartPoint = nil
      didDragStart = false
      
    case .canvasWaiting:
      guard let selectionRect = canvasView.selectionRect else { return }
      // select concepts that intersect with the selection rect
      if let concepts = matchedConcepts(inRect: selectionRect) {
        safeTransiton {
          try stateManager.toMultipleSelectedElements(elements: concepts)
        }
      }
      
      canvasView.selectFromPoint = nil
      canvasView.selectToPoint = nil
      canvasView.needsDisplay = true
      didDragStart = false
    default:
      return
    }
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
    canvasView.needsDisplay = true
  }
}

// MARK: - StateManagerDelegate

extension CanvasViewController: StateManagerDelegate {
  func transitionSuccesfull() {
    canvasView.needsDisplay = true
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
    guard case .selectedElement(let element) = currentState else { return }
    let concept: Concept = element as! Concept
    
    concept.attributedStringValue = textField.attributedStringValue
    dismissTextField()
    
    transitionedToSelectedElement(fromState: fromState)
  }
  
  func transitionedToEditingElement(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
    
    guard case .editingElement(let element) = currentState else { return }
    let concept: Concept = element as! Concept
    concept.isEditable = true
    
    showTextField(atPoint: concept.point, text: concept.attributedStringValue)
  }
  
  func transitionedToSelectingElements(fromState: CanvasState) {
    commonTransitionBehavior(fromState)
    
    // TODO: render the selection rectangle
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
    case .multipleSelectedElements(let elements):
      unselect(elements: elements)
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
      if case .editingElement(let element) = currentState {
        safeTransiton {
          try stateManager.toSelectedElementSavingChanges(element: element)
        }
      } else {
        safeTransiton {
          try stateManager.toCanvasWaiting(savingConceptWithText: control.attributedStringValue)
        }
      }
      return true
    default:
      return false
    }
  }
}
