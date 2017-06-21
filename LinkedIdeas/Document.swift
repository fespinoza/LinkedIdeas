//
//  Document.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

public class Document: NSDocument {
  var documentData = DocumentData()
  var observer: DocumentObserver?

  public var concepts: [Concept] = [Concept]() {
    willSet {
      for concept in concepts {
        stopObserving(concept: concept)
      }
    }
    didSet {
      for concept in concepts {
        startObserving(concept: concept)
      }
    }
  }
  public var links: [Link] = [Link]() {
    willSet {
      for link in links {
        stopObserving(link: link)
      }
    }
    didSet {
      for link in links {
        startObserving(link: link)
      }
    }
  }

  public var rect: NSRect {
    let minX = concepts.map { $0.rect.minX }.min() ?? 0
    let minY = concepts.map { $0.rect.minY }.min() ?? 0
    let maxX = concepts.map { $0.rect.maxX }.max() ?? 800
    let maxY = concepts.map { $0.rect.maxY }.max() ?? 600

    return NSRect(
      point1: NSPoint(x: minX, y: minY),
      point2: NSPoint(x: maxX, y: maxY)
    )
  }

  private var KVOContext: Int = 0

  override public func makeWindowControllers() {
    let storyboard = NSStoryboard(name: "Main", bundle: nil)

    if let windowController = storyboard.instantiateController(
                                withIdentifier: "Document Window Controller"
                              ) as? WindowController {
      self.addWindowController(windowController)
    }
  }

  override public class func autosavesInPlace() -> Bool {
    return true
  }

  override public func data(ofType typeName: String) throws -> Data {
    documentData.writeConcepts = concepts
    documentData.writeLinks = links
    Swift.print("write data!")
    return NSKeyedArchiver.archivedData(withRootObject: documentData)
  }

  override public func read(from data: Data, ofType typeName: String) throws {
    Swift.print("Document: -read")
    guard let documentData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DocumentData else {
      return
    }
    self.documentData = documentData
    if let readConcepts = documentData.readConcepts {
      concepts = readConcepts
    }
    if let readLinks = documentData.readLinks {
      links = readLinks
    }
  }

  // MARK: - KeyValue Observing

  func startObserving(concept: Concept) {
    concept.addObserver(self, forKeyPath: Concept.attributedStringValuePath, options: .old, context: &KVOContext)
  }

  func stopObserving(concept: Concept) {
    concept.removeObserver(self, forKeyPath: Concept.attributedStringValuePath, context: &KVOContext)
  }

  func startObserving(link: Link) {
    link.addObserver(self, forKeyPath: Link.colorPath, options: .old, context: &KVOContext)
    link.addObserver(self, forKeyPath: Link.attributedStringValuePath, options: .old, context: &KVOContext)
  }

  func stopObserving(link: Link) {
    link.removeObserver(self, forKeyPath: Link.colorPath, context: &KVOContext)
    link.removeObserver(self, forKeyPath: Link.attributedStringValuePath, context: &KVOContext)
  }

  override public func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey : Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    guard context == &KVOContext else {
      // If the context does not match, this message
      // must be intended for our superclass.
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }

    if let keyPath = keyPath, let object = object, let change = change {
      var oldValue: Any? = change[NSKeyValueChangeKey.oldKey]
      if oldValue is NSNull {
        oldValue = nil
      }

      if let object = object as? NSObject {
        undoManager?.registerUndo(withTarget: (object), handler: { (object) in
          object.setValue(oldValue, forKey: keyPath)
        })
      }

      switch object {
      case let concept as Concept:
        observer?.documentChanged(withElement: concept)
      case let link as Link:
        observer?.documentChanged(withElement: link)
      default:
        break
      }
    }
  }
}

extension Document: LinkedIdeasDocument {
  func save(concept: Concept) {
    concepts.append(concept)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.remove(concept:)),
      object: concept)
    observer?.documentChanged(withElement: concept)
  }

  func remove(concept: Concept) {
    concepts.remove(at: concepts.index(of: concept)!)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.save(concept:)),
      object: concept)
    observer?.documentChanged(withElement: concept)
  }

  func save(link: Link) {
    links.append(link)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.remove(link:)),
      object: link)
    observer?.documentChanged(withElement: link)
  }

  func remove(link: Link) {
    links.remove(at: links.index(of: link)!)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.save(link:)),
      object: link)
    observer?.documentChanged(withElement: link)
  }

  func move(concept: Concept, toPoint: NSPoint) {
    Swift.print("move concept \(concept) toPoint: \(toPoint)")
    let originalPoint = concept.point
    concept.point = toPoint
    observer?.documentChanged(withElement: concept)

    undoManager?.registerUndo(withTarget: self, handler: { (object) in
      object.move(concept: concept, toPoint: originalPoint)
    })
  }

}

extension Document: CanvasViewDataSource {
  public func selectedDrawableElements() -> [DrawableElement]? {
    return drawableElements
  }

  public var drawableElements: [DrawableElement] {
    var elements: [DrawableElement] = []

    elements += concepts.map {
      DrawableConcept(concept: $0 as GraphConcept) as DrawableElement
    }

    elements += links.map {
      DrawableLink(link: $0 as GraphLink) as DrawableElement
    }

    return elements
  }
}
