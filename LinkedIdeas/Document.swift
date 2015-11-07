//
//  Document.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class Concept {
  let stringValue = "Hello World!"
  var point: NSPoint
  var added: Bool = false
  var rect: NSRect {
    let offset: CGFloat = 20.0
    let size = stringValue.sizeWithAttributes(nil)
    let x = self.point.x - size.width / 2.0 - offset
    let y = self.point.y - size.height / 2.0 - offset
    let point = NSPoint(x: x, y: y)
    let bigSize = NSSize(width: size.width + offset, height: size.height + offset)
    return NSRect(origin: point, size: bigSize)
  }
  
  init(point: NSPoint) {
    self.point = point
  }
  
  func draw() {
    stringValue.drawAtPoint(rect.origin, withAttributes: nil)
  }
}

class Document: NSDocument, CanvasViewDelegate {
  
  @IBOutlet weak var canvas: CanvasView!
  
  override init() {
    super.init()
    // Add your subclass-specific initialization here.
  }
  
  override func windowControllerDidLoadNib(aController: NSWindowController) {
    super.windowControllerDidLoadNib(aController)
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    canvas.delegate = self
  }
  
  override class func autosavesInPlace() -> Bool {
    return true
  }
  
  override var windowNibName: String? {
    // Returns the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
    return "Document"
  }
  
  override func dataOfType(typeName: String) throws -> NSData {
    // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
  }
  
  override func readFromData(data: NSData, ofType typeName: String) throws {
    // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
    // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
  }
  
  // MARK: - CanvasViewDelegate
  
  func singleClick(event: NSEvent) {
    let point = canvas.convertPoint(event.locationInWindow, fromView: nil)
    print("single click in (\(point.x), \(point.y))")
    canvas.concepts.append(Concept(point: point))
  }
  
}
