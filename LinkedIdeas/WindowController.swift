//
//  WindowController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 30/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  @IBOutlet var ultraWindow: NSWindow!
  
  @IBOutlet weak var canvas: CanvasView!
  @IBOutlet weak var selectMode: NSButton!
  @IBOutlet weak var conceptMode: NSButton!
  @IBOutlet weak var linkMode: NSButton!
  
  @IBOutlet weak var colorSelector: NSColorWell!
  
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
    
    if (sender as! NSObject == alignVerticallyLeftButton) {
      alignConcepts("left", concepts: canvas.selectedConcepts())
    }
    
    if (sender as! NSObject == alignVerticallyCenterButton) {
      alignConcepts("center", concepts: canvas.selectedConcepts())
    }
    
    if (sender as! NSObject == alignVerticallyRightButton) {
      alignConcepts("right", concepts: canvas.selectedConcepts())
    }
    
  }
  
  func alignConcepts(mode: String, concepts: [Concept]) {
    let currentDocument = document as! Document
    
    if (mode == "center") {
      let sortedConcepts = concepts.sort { (p1: Concept, p2: Concept) -> Bool in return p1.point.x < p2.point.x }
      let minimunXCoordinate = sortedConcepts.first!.point.x
      
      for concept in concepts {
        let verticallyCenterAlignedPoint = NSMakePoint(minimunXCoordinate, concept.point.y)
        canvas.conceptViewFor(concept).textField.attributedStringValue = concept.attributedStringValue
        currentDocument.changeConceptPoint(concept, fromPoint: concept.point, toPoint: verticallyCenterAlignedPoint)
      }
      return
    }
    
    if (mode == "left") {
      let sortedConcepts = concepts.sort { (p1: Concept, p2: Concept) -> Bool in return p1.minimalRect.origin.x < p2.minimalRect.origin.x }
      let minimunXCoordinate = sortedConcepts.first!.minimalRect.origin.x
      
      for concept in concepts {
        let newX: CGFloat = minimunXCoordinate + concept.minimalRect.width / 2
        let verticallyCenterAlignedPoint = NSMakePoint(newX, concept.point.y)
        canvas.conceptViewFor(concept).textField.attributedStringValue = concept.attributedStringValue
        currentDocument.changeConceptPoint(concept, fromPoint: concept.point, toPoint: verticallyCenterAlignedPoint)
      }
      return
    }
    
    if (mode == "right") {
      let sortedConcepts = concepts.sort { (p1: Concept, p2: Concept) -> Bool in return p1.minimalRect.maxX > p2.minimalRect.maxX }
      let minimunXCoordinate = sortedConcepts.first!.minimalRect.maxX
      
      for concept in concepts {
        let newX: CGFloat = minimunXCoordinate - concept.minimalRect.width / 2
        let verticallyCenterAlignedPoint = NSMakePoint(newX, concept.point.y)
        canvas.conceptViewFor(concept).textField.attributedStringValue = concept.attributedStringValue
        currentDocument.changeConceptPoint(concept, fromPoint: concept.point, toPoint: verticallyCenterAlignedPoint)
      }
    }
  }
  
  
}
