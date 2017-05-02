//
//  CanvasViewController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController {
  @IBOutlet weak var canvasView: CanvasView!
  @IBOutlet weak var scrollView: NSScrollView!

  var dragCount = 0
  var didShiftDragStart = false
  // to register the beginning of the drag
  // for undo purposes
  var dragStartPoint: NSPoint?

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
    canvasView.frame = NSRect(x: 0, y: 0, width: 3000, height: 2000)
    let canvasViewCenterForScroll = NSPoint(
      x: (canvasView.frame.center.x - scrollView.frame.center.x),
      y: (canvasView.frame.center.y - scrollView.frame.center.y)
    )
    scrollView.scroll(canvasViewCenterForScroll)

    textField.delegate = self
    canvasView.addSubview(textField)

    stateManager.delegate = self

    canvasView.window?.makeFirstResponder(canvasView)
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
    let results = document.concepts.filter { $0.rect.contains(clickedPoint) }
    guard !results.isEmpty else {
      return nil
    }
    return results
  }

  func clickedElements(atPoint clickedPoint: NSPoint) -> [Element]? {
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
  func matchedConcepts(inRect rect: NSRect) -> [Concept]? {
    let results = document.concepts.filter { (concept) -> Bool in
      return rect.intersects(concept.rect)
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
    return event.modifierFlags.contains(.shift) || didShiftDragStart
  }
}
