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
    if let readConcepts = currentDocument.documentData.readConcepts { canvas.concepts = readConcepts }
    if let readLinks = currentDocument.documentData.readLinks { canvas.links = readLinks }
    currentDocument.canvas = canvas
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
}
