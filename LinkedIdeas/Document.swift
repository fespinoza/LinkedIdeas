//
//  Document.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

enum Mode: String {
  case Select = "select"
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
  var documentData = DocumentData()
  
  override init() {
    super.init()
    // Add your subclass-specific initialization here.
  }
  
  var canvas: CanvasView!

  override class func autosavesInPlace() -> Bool {
    return true
  }

  override func makeWindowControllers() {
    let windowController = WindowController(windowNibName: "Document")
    addWindowController(windowController)
  }

  override func dataOfType(typeName: String) throws -> NSData {
    // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    Swift.print("saving document..")
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
}
