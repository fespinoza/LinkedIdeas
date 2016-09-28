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

protocol StateManagerDelegate {
  // elemnts
  func unselectAllElements()
  
  // concepts
  func cancelConceptCreation()
  func saveConcept(text: NSAttributedString, atPoint: NSPoint) -> Bool
  
  // text field
  func showTextField(atPoint: NSPoint)
  func dismissTextField()
}

enum CanvasState {
  case canvasWaiting
  case newConcept(point: NSPoint)
  case selectedElements
}

extension CanvasState: Equatable {
  static func == (lhs: CanvasState, rhs: CanvasState) -> Bool {
    switch (lhs, rhs) {
    case (.newConcept(let a), .newConcept(let b)) where a == b: return true
    case (.canvasWaiting, .canvasWaiting): return true
    case (.selectedElements, .selectedElements): return true
    default: return false
    }
  }
}

struct StateManager {
  var currentState: CanvasState {
    didSet {
      print("Transitioned to \(currentState)")
    }
  }
  var delegate: StateManagerDelegate?
  
  init(initialState: CanvasState) {
    currentState = initialState
  }
  
  mutating func toNewConcept(atPoint point: NSPoint) -> Bool {
    switch currentState {
    case .canvasWaiting:
      break
    case .newConcept:
      delegate?.dismissTextField()
    case .selectedElements:
      delegate?.unselectAllElements()
    }
    
    delegate?.showTextField(atPoint: point)
    currentState = .newConcept(point: point)
    return true
  }
  
  mutating func saveNewConcept(text: NSAttributedString) -> Bool {
    switch currentState {
    case .newConcept(let point):
      guard let success = delegate?.saveConcept(text: text, atPoint: point) else {
        return false
      }
      delegate?.dismissTextField()
      currentState = .canvasWaiting
      return success
    default:
      return false
    }
  }
  
  mutating func cancelNewConcept() -> Bool {
    switch currentState {
    case .newConcept:
      currentState = .canvasWaiting
      
      delegate?.dismissTextField()
      return true
    default:
      return false
    }
  }
}

class CanvasViewController: NSViewController {
  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var scrollView: NSScrollView!
  
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
}

extension CanvasViewController {
  override func mouseDown(with event: NSEvent) {
    let point = convertToCanvasCoordinates(point: event.locationInWindow)
    if event.clickCount == 1 {
      let _ = stateManager.cancelNewConcept()
    } else if event.clickCount == 2 {
      let _ = stateManager.toNewConcept(atPoint: point)
    }
  }
}

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

extension CanvasViewController: DocumentObserver {
  func documentChanged(withElement element: Element) {
    canvasView.needsDisplay = true
  }
}

extension CanvasViewController: StateManagerDelegate {
  // elemnts
  func unselectAllElements() {}
  
  // concepts
  func cancelConceptCreation() {}
  
  func saveConcept(text: NSAttributedString, atPoint point: NSPoint) -> Bool {
    guard text.string != "" else { return false }
    
    let newConcept = Concept(attributedStringValue: text, point: point)
    
    document.save(concept: newConcept)
    return true
  }
  
  // text field
  func showTextField(atPoint point: NSPoint) {
    textField.frame = NSRect(center: point, size: NSMakeSize(60, 40))
    textField.isEditable = true
    textField.isHidden = false
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

extension CanvasViewController: NSTextFieldDelegate {
  // Invoked when users press keys with predefined bindings in a cell of the specified control.
  func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    switch commandSelector {
    case #selector(NSResponder.insertNewline(_:)):
      return stateManager.saveNewConcept(text: control.attributedStringValue)
    default:
      return false
    }
  }
}
