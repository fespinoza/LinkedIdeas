//
//  Document.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

enum Mode: String {
  case Concepts = "concepts"
  case Links = "links"
}

class DocumentData: NSObject, NSCoding {
  var readConcepts: [Concept]?
  var readLinks: [Link]?
  var writeConcepts: [Concept]?
  var writeLinks: [Link]?

  override init() {
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    readConcepts = aDecoder.decodeObjectForKey("concepts") as! [Concept]?
    readLinks = aDecoder.decodeObjectForKey("links") as! [Link]?
  }

  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(writeConcepts, forKey: "concepts")
    aCoder.encodeObject(writeLinks, forKey: "links")
  }
}

class Document: NSDocument {

  @IBOutlet weak var canvas: CanvasView!
  @IBOutlet weak var conceptMode: NSButton!
  @IBOutlet weak var linkMode: NSButton!

  @IBOutlet var ultraWindow: NSWindow!
  var documentData = DocumentData()
  var editionMode = Mode.Concepts

  override init() {
    super.init()
    // Add your subclass-specific initialization here.
  }

  override func windowControllerDidLoadNib(aController: NSWindowController) {
    super.windowControllerDidLoadNib(aController)
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    if let readConcepts = documentData.readConcepts { canvas.concepts = readConcepts }
    if let readLinks = documentData.readLinks { canvas.links = readLinks }
    canvas.mode = editionMode
    ultraWindow.acceptsMouseMovedEvents = true
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
    documentData.writeConcepts = canvas.concepts
    documentData.writeLinks = canvas.links
    return NSKeyedArchiver.archivedDataWithRootObject(documentData)
  }

  override func readFromData(data: NSData, ofType typeName: String) throws {
    // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
    // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
    documentData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! DocumentData
  }

  @IBAction func changeMode(sender: NSButton) {
    if sender == conceptMode {
      editionMode = .Concepts
    } else {
      editionMode = .Links
    }
    canvas.mode = editionMode
  }
}
