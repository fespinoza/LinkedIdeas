//
//  Document.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

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
  var links: [Link] = [Link]() {
    willSet {
      for link in links {
        stopObservingLink(link)
      }
    }
    didSet {
      for link in links {
        startObservingLink(link)
      }
    }
  }
  
  var observer: DocumentObserver?
  
  private var KVOContext: Int = 0
  
  override init() {
    super.init()
    // Add your subclass-specific initialization here.
  }
  
  // MARK: - LinkedIdeasDocument
  
  func saveConcept(_ concept: Concept) {
    concepts.append(concept)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.removeConcept(_:)),
      object: concept)
    observer?.conceptAdded(concept)
  }
  
  func removeConcept(_ concept: Concept) {
    concepts.remove(at: concepts.index(of: concept)!)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.saveConcept(_:)),
      object: concept)
    observer?.conceptRemoved(concept)
  }
  
  func saveLink(_ link: Link) {
    links.append(link)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.removeLink(_:)),
      object: link)
    observer?.linkAdded(link)
  }
  
  func removeLink(_ link: Link) {
    links.remove(at: links.index(of: link)!)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.saveLink(_:)),
      object: link)
    observer?.linkRemoved(link)
  }
  
  func changeConceptPoint(_ concept: Concept, fromPoint pointA: NSPoint, toPoint pointB: NSPoint) {
    concept.point = pointB
    observer?.conceptUpdated(concept)
    undoManager?.prepare(withInvocationTarget: self).changeConceptPoint(concept, fromPoint: pointB, toPoint: pointA)
  }

  override class func autosavesInPlace() -> Bool {
    return true
  }

  override func makeWindowControllers() {
    let windowController = WindowController(windowNibName: "Document")
    addWindowController(windowController)
  }

  override func data(ofType typeName: String) throws -> Data {
    // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    documentData.writeConcepts = concepts
    documentData.writeLinks = links
    return NSKeyedArchiver.archivedData(withRootObject: documentData)
  }

  override func read(from data: Data, ofType typeName: String) throws {
    // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
    // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
    documentData = NSKeyedUnarchiver.unarchiveObject(with: data) as! DocumentData
    if let readConcepts = documentData.readConcepts {
      concepts = readConcepts
    }
    if let readLinks = documentData.readLinks {
      links = readLinks
    }
  }
  
  // MARK: - KeyValue Observing
  
  func startObservingConcept(_ concept: Concept) {
    concept.addObserver(self, forKeyPath: Concept.attributedStringValuePath, options: .old, context: &KVOContext)
  }
  
  func stopObservingConcept(_ concept: Concept) {
    concept.removeObserver(self, forKeyPath: Concept.attributedStringValuePath, context: &KVOContext)
  }
  
  func startObservingLink(_ link: Link) {
    link.addObserver(self, forKeyPath: Link.colorPath, options: .old, context: &KVOContext)
  }
  
  func stopObservingLink(_ link: Link) {
    link.removeObserver(self, forKeyPath: Link.colorPath, context: &KVOContext)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {
    guard context == &KVOContext else {
      // If the context does not match, this message
      // must be intended for our superclass.
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }
    
    if let keyPath = keyPath, let object = object, let change = change {
      var oldValue: AnyObject? = change[NSKeyValueChangeKey.oldKey]
      if oldValue is NSNull {
        oldValue = nil
      }
      
      undoManager?.prepare(withInvocationTarget: object).setValue(oldValue, forKey: keyPath)
      
      if let concept = object as? Concept { observer?.conceptUpdated(concept) }
      if let link = object as? Link { observer?.linkUpdated(link) }
    }
  }
}
