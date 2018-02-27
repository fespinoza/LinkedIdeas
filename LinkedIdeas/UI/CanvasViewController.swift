//
//  CanvasViewController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

class CanvasViewController: NSViewController {
  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var scrollView: NSScrollView!

  // for handling multiple "paste" results, to move the pasting result a bit each time
  var lastCopyIndex = 0

  var dragCount = 0
  var didShiftDragStart = false
  // to register the beginning of the drag
  // for undo purposes
  var dragStartPoint: CGPoint?

  var stateManager = StateManager(initialState: .canvasWaiting)
  var currentState: CanvasState {
    get {
      return stateManager.currentState
    }
    set(newState) {
      stateManager.currentState = newState
    }
  }

  // MARK: - Text Handling
  let textContainer = NSTextContainer()

  lazy var layoutManager: NSLayoutManager = {
    let layoutManager = NSLayoutManager()
    layoutManager.addTextContainer(textContainer)
    return layoutManager
  }()

  lazy var textStorage: NSTextStorage = {
    let textStorage = NSTextStorage()
    textStorage.addLayoutManager(layoutManager)
    return textStorage
  }()

  let defaultTextAttributes: [NSAttributedStringKey: Any] = [
    .foregroundColor: Color.black,
    .font: Font.systemFont(ofSize: 12)
  ]

  lazy var textView: NSTextView = {
    let textView = NSTextView(frame: CGRect.zero, textContainer: textContainer)
    textView.isHidden = true
    textView.isEditable = false
    textView.isRichText = true
    textView.isVerticallyResizable = true
    textView.isHorizontallyResizable = true
    textView.backgroundColor = NSColor.lightGray
    textView.typingAttributes = self.defaultTextAttributes

    textView.delegate = self
    return textView
  }()

  var currentEditingConceptCenterPoint: CGPoint = CGPoint.zero
  var editingConcept: Concept?

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
    canvasView.frame = CGRect(x: 0, y: 0, width: 3000, height: 2000)
    let canvasViewCenterForScroll = CGPoint(
      x: (canvasView.frame.center.x - scrollView.frame.center.x),
      y: (canvasView.frame.center.y - scrollView.frame.center.y)
    )
    scrollView.scroll(canvasViewCenterForScroll)
    scrollView.allowsMagnification = true

    stateManager.delegate = self

    canvasView.addSubview(textView)

    canvasView.window?.makeFirstResponder(canvasView)
  }

  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    print("-prepareForSegue")
  }

  func convertToCanvasCoordinates(point: CGPoint) -> CGPoint {
    return canvasView.convert(point, from: nil)
  }

  func clickedSingleConcept(atPoint clickedPoint: CGPoint) -> Concept? {
    if let concepts = clickedConcepts(atPoint: clickedPoint), concepts.count == 1 {
      return concepts.first
    }

    return nil
  }

  func clickedSingleElement(atPoint clickedPoint: CGPoint) -> Element? {
    if let elements = clickedElements(atPoint: clickedPoint), elements.count == 1 {
      return elements.first
    }

    return nil
  }

  func clickedConcepts(atPoint clickedPoint: CGPoint) -> [Concept]? {
    let results = document.concepts.filter { $0.area.contains(clickedPoint) }
    guard !results.isEmpty else {
      return nil
    }
    return results
  }

  func clickedElements(atPoint clickedPoint: CGPoint) -> [Element]? {
    var results = [Element]()
    let clickedConcepts: [Element] = document.concepts.filter { (concept) -> Bool in
      return concept.contains(point: clickedPoint)
    }
    let clickedLinks: [Element] = document.links.filter { (link) -> Bool in
      return link.contains(point: clickedPoint)
    }

    results.append(contentsOf: clickedConcepts)
    results.append(contentsOf: clickedLinks)

    guard results.count > 0 else {
      return nil
    }
    return results
  }

  /// matchedConcepts: custom description
  ///
  /// - Parameter rect: the area to match
  /// - Returns:
  ///   - nil if there were no concepts intersecting the given area
  ///   - [Concept] if there were concepts intersecting the given area
  func matchedConcepts(inRect rect: CGRect) -> [Concept]? {
    let results = document.concepts.filter { (concept) -> Bool in
      return rect.intersects(concept.area)
    }
    guard results.count > 0 else {
      return nil
    }
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

  func isDragShiftEvent(_ event: NSEvent) -> Bool {
    return isPressingShift(event: event) || didShiftDragStart
  }

  func isPressingShift(event: NSEvent) -> Bool {
    return event.modifierFlags.contains(NSEvent.ModifierFlags.shift)
  }

  // MARK: - current State data helpers

  func selectedElements() -> [Element]? {
    switch currentState {
    case .selectedElement(let element):
      return [element]
    case .multipleSelectedElements(let elements):
      return elements
    default:
      return nil
    }
  }

  func singleSelectedElement() -> Element? {
    switch currentState {
    case .selectedElement(let element):
      return element
    default:
      return nil
    }
  }

  func currentlyEditingElement() -> Element? {
    switch currentState {
    case .editingElement(let element):
      return element
    default:
      return nil
    }
  }
}
