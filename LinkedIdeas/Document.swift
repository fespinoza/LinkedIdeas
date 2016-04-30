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

protocol DocumentObserver {
  func conceptAdded(concept: Concept)
  func conceptRemoved(concept: Concept)
  func conceptUpdated(concept: Concept)
  
  func linkAdded(link: Link)
  func linkRemoved(link: Link)
}

class Document: NSDocument, LinkedIdeasDocument {
  var documentData = DocumentData()
  
  var concepts: [Concept] = [Concept]() {
    willSet {
      for concept in concepts {
        stopObservingConcept(concept)
      }
    }
    didSet {
      for concept in concepts {
        startObservingConcept(concept)
      }
    }
  }
  var links: [Link] = [Link]()
  
  var observer: DocumentObserver?
  
  private var KVOContext: Int = 0
  
  override init() {
    super.init()
    // Add your subclass-specific initialization here.
  }
  
  // MARK: - LinkedIdeasDocument
  
  func saveConcept(concept: Concept) {
    Swift.print("add concept \(concept)")
    concepts.append(concept)
    undoManager?.registerUndoWithTarget(
      self,
      selector: #selector(Document.removeConcept(_:)),
      object: concept)
    observer?.conceptAdded(concept)
  }
  
  func removeConcept(concept: Concept) {
    Swift.print("remove concept \(concept)")
    concepts.removeAtIndex(concepts.indexOf(concept)!)
    undoManager?.registerUndoWithTarget(
      self,
      selector: #selector(Document.saveConcept(_:)),
      object: concept)
    observer?.conceptRemoved(concept)
  }
  
  func saveLink(link: Link) {
    Swift.print("add link \(link)")
    links.append(link)
    undoManager?.registerUndoWithTarget(
      self,
      selector: #selector(Document.removeLink(_:)),
      object: link)
    observer?.linkAdded(link)
  }
  
  func removeLink(link: Link) {
    Swift.print("remove link \(link)")
    links.removeAtIndex(links.indexOf(link)!)
    undoManager?.registerUndoWithTarget(
      self,
      selector: #selector(Document.saveLink(_:)),
      object: link)
    observer?.linkRemoved(link)
  }
  
  func changeConceptPoint(concept: Concept, fromPoint pointA: NSPoint, toPoint pointB: NSPoint) {
    concept.point = pointB
    observer?.conceptUpdated(concept)
    undoManager?.prepareWithInvocationTarget(self).changeConceptPoint(concept, fromPoint: pointB, toPoint: pointA)
  }

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
    documentData.writeConcepts = concepts
    documentData.writeLinks = links
    return NSKeyedArchiver.archivedDataWithRootObject(documentData)
  }

  override func readFromData(data: NSData, ofType typeName: String) throws {
    // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
    // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
    documentData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! DocumentData
    if let readConcepts = documentData.readConcepts {
      concepts = readConcepts
    }
    if let readLinks = documentData.readLinks {
      links = readLinks
    }
  }
  
  // MARK: - KeyValue Observing
  
  func startObservingConcept(concept: Concept) {
    concept.addObserver(self, forKeyPath: Concept.attributedStringValuePath, options: .Old, context: &KVOContext)
  }
  
  func stopObservingConcept(concept: Concept) {
    concept.removeObserver(self, forKeyPath: Concept.attributedStringValuePath, context: &KVOContext)
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    guard context == &KVOContext else {
      // If the context does not match, this message
      // must be intended for our superclass.
      super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
      return
    }
    
    if let keyPath = keyPath, object = object, change = change {
      var oldValue: AnyObject? = change[NSKeyValueChangeOldKey]
      if oldValue is NSNull {
        oldValue = nil
      }
      if let concept = object as? Concept {
        undoManager?.prepareWithInvocationTarget(object).setValue(oldValue, forKey: keyPath)
        observer?.conceptUpdated(concept)
      }
    }
  }
}
