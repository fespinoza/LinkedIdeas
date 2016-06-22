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
  @IBOutlet weak var modeSelector: NSSegmentedControl!
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
  
  let numberOne: UInt16 = 18
  let numberTwo: UInt16 = 19
  let numberThree: UInt16 = 20
  let numberFour: UInt16 = 21
  let numberFive: UInt16 = 22
  let numberSix: UInt16  = 23

  
  // MARK: - Keyboard Events
  override func keyDown(theEvent: NSEvent) {
    if (theEvent.modifierFlags.contains(.ShiftKeyMask)) {
      switch theEvent.keyCode {
      case numberOne:
        alignVertically(alignVerticallyLeftButton)
      case numberTwo:
        alignVertically(alignVerticallyCenterButton)
      case numberThree:
        alignVertically(alignVerticallyRightButton)
      case numberFour:
        alignVertically(alignHorizontallyButton)
      case numberFive:
        alignVertically(equalHorizontalSpaceButton)
      case numberSix:
        alignVertically(equalVerticalSpaceButton)
      default: break
      }
    } else {
      switch theEvent.keyCode {
      case numberOne:
        canvas.mode = .Select
        modeSelector.selectedSegment = 0
      case numberTwo:
        canvas.mode = .Concepts
        modeSelector.selectedSegment = 1
      case numberThree:
        canvas.mode = .Links
        modeSelector.selectedSegment = 2
      default: break
      }
    }
  }
  
  @IBAction func changeMode(sender: NSSegmentedControl) {
    switch sender.doubleValueForSelectedSegment {
    case 1:
      editionMode = .Concepts
    case 2:
      editionMode = .Links
    default:
      editionMode = .Select
    }
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
