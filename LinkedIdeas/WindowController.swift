//
//  WindowController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 30/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, AlignmentFunctions {
  @IBOutlet var ultraWindow: NSWindow!
  
  @IBOutlet weak var canvas: CanvasView!
  @IBOutlet weak var selectMode: NSButton!
  @IBOutlet weak var conceptMode: NSButton!
  @IBOutlet weak var linkMode: NSButton!
  
  @IBOutlet weak var colorSelector: NSColorWell!
  
  @IBOutlet weak var scrollView: NSScrollView!
  dynamic var selectedColor: NSColor = Link.defaultColor
  
  var editionMode = Mode.Concepts
  
  convenience init() {
    self.init(window: nil)
  }
  
  override init(window: NSWindow?) {
    super.init(window: window)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    ultraWindow.acceptsMouseMovedEvents = true
    
    let currentDocument = document as! Document
    canvas.document = currentDocument
    canvas.frame = scrollView.bounds
  }
  
  // MARK: - Keyboard Events
  override func keyDown(theEvent: NSEvent) {
    switch theEvent.keyCode {
    case 18:
      canvas.mode = .Select
      selectMode.cell?.state = 1
    case 19:
      canvas.mode = .Concepts
      conceptMode.cell?.state = 1
    case 20:
      canvas.mode = .Links
      linkMode.cell?.state = 1
    default: break
    }
  }
  
  @IBAction func changeMode(sender: NSButton) {
    switch sender {
    case conceptMode:
      editionMode = .Concepts
    case linkMode:
      editionMode = .Links
    default:
      editionMode = .Select
    }
    Swift.print(editionMode)
    canvas.mode = editionMode
  }
  
  @IBAction func selectColor(sender: AnyObject) {
    let newColor = colorSelector.color
    let selectedLinks = canvas.links.filter { $0.isSelected }
    for link in selectedLinks {
      link.color = newColor
      canvas.linkViewFor(link).needsDisplay = true
    }
  }
  
  // MARK: - Align Buttons
  @IBOutlet weak var alignVerticallyLeftButton: NSButton!
  @IBOutlet weak var alignVerticallyCenterButton: NSButton!
  @IBOutlet weak var alignVerticallyRightButton: NSButton!
  
  @IBOutlet weak var alignHorizontallyButton: NSButton!
  
  @IBOutlet weak var equalVerticalSpaceButton: NSButton!
  @IBOutlet weak var equalHorizontalSpaceButton: NSButton!
  
  @IBAction func alignVertically(sender: AnyObject) {
    let elements = canvas.selectedConcepts().map { $0 as SquareElement }
    
    switch (sender as! NSObject) {
    case alignVerticallyLeftButton:
      verticallyLeftAlign(elements)
    case alignVerticallyCenterButton:
      verticallyCenterAlign(elements)
    case alignVerticallyRightButton:
      verticallyRightAlign(elements)
    case alignHorizontallyButton:
      horizontallyAlign(elements)
    case equalVerticalSpaceButton:
      equalVerticalSpace(elements)
    case equalHorizontalSpaceButton:
      equalHorizontalSpace(elements)
    default:
      Swift.print("not implemented")
    }
  }
  
  func setNewPoint(newPoint: NSPoint, forElement element: SquareElement) {
    let concept = element as! Concept
    canvas.conceptViewFor(concept).textField.attributedStringValue = concept.attributedStringValue
    canvas.document.changeConceptPoint(concept, fromPoint: concept.point, toPoint: newPoint)
  }
}
