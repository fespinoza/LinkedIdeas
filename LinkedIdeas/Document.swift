//
//  Document.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class Document: NSDocument {
  var documentData = DocumentData()
  var observer: DocumentObserver?
  
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
  
  private var KVOContext: Int = 0
  
  override init() {
    super.init()
    Swift.print("Document: -init")
  }
  
  override func makeWindowControllers() {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)
    let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! WindowController
    self.addWindowController(windowController)
    Swift.print("Document: addWindowController")
  }
  
  override class func autosavesInPlace() -> Bool {
    return true
  }
  
  override func data(ofType typeName: String) throws -> Data {
    documentData.writeLinks = links
    return NSKeyedArchiver.archivedData(withRootObject: documentData)
  }
  
  override func read(from data: Data, ofType typeName: String) throws {
    Swift.print("Document: -read")
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
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &KVOContext else {
      // If the context does not match, this message
      // must be intended for our superclass.
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }
    
    // if let keyPath = keyPath, let object = object, let change = change {
    if let object = object, let change = change {
      var oldValue: Any? = change[NSKeyValueChangeKey.oldKey]
      if oldValue is NSNull {
        oldValue = nil
      }
      
      // (undoManager?.prepare(withInvocationTarget: object) as! NSObject).setValue(oldValue, forKey: keyPath)
      
      if let concept = object as? Concept { observer?.conceptUpdated(concept) }
      if let link = object as? Link { observer?.linkUpdated(link) }
    }
  }
}

extension Document: LinkedIdeasDocument {
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
    
    // undoManager?.prepare(withInvocationTarget: self).changeConceptPoint(concept, fromPoint: pointB, toPoint: pointA)
  }
  
}
