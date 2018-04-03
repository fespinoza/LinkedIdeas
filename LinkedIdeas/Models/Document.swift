//
//  Document.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

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

  public var rect: CGRect {
    let minX = concepts.map { $0.area.minX }.min() ?? 0
    let minY = concepts.map { $0.area.minY }.min() ?? 0
    let maxX = concepts.map { $0.area.maxX }.max() ?? 800
    let maxY = concepts.map { $0.area.maxY }.max() ?? 600

    return CGRect(
      point1: CGPoint(x: minX, y: minY),
      point2: CGPoint(x: maxX, y: maxY)
    )
  }

  private var KVOContext: Int = 0

  override public func makeWindowControllers() {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)

    if let windowController = storyboard.instantiateController(
                                withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Document Window Controller")
                              ) as? WindowController {
      self.addWindowController(windowController)
    }
  }

  override public class var autosavesInPlace: Bool {
    return true
  }

  override public func data(ofType typeName: String) throws -> Data {
    Swift.print("write data!")
    NSKeyedArchiver.setClassName("LinkedIdeas.DocumentData", for: DocumentData.self)
    NSKeyedArchiver.setClassName("LinkedIdeas.Concept", for: Concept.self)
    NSKeyedArchiver.setClassName("LinkedIdeas.Link", for: Link.self)

    let writeDocumentData = DocumentData(concepts: self.concepts, links: self.links)
    return NSKeyedArchiver.archivedData(withRootObject: writeDocumentData)
  }

  override public func read(from data: Data, ofType typeName: String) throws {
    Swift.print("Document: -read")
    NSKeyedUnarchiver.setClass(DocumentData.self, forClassName: "LinkedIdeas.DocumentData")
    NSKeyedUnarchiver.setClass(Concept.self, forClassName: "LinkedIdeas.Concept")
    NSKeyedUnarchiver.setClass(Link.self, forClassName: "LinkedIdeas.Link")
    guard let documentData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DocumentData else {
      return
    }
    self.documentData = documentData
    self.concepts = documentData.concepts
    self.links = documentData.links

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

  // swiftlint:disable:next block_based_kvo
  override public func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey: Any]?,
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
  @objc func save(concept: Concept) {
    concepts.append(concept)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.remove(concept:)),
      object: concept)
    observer?.documentChanged(withElement: concept)
  }

  @objc func remove(concept: Concept) {
    concepts.remove(at: concepts.index(of: concept)!)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.save(concept:)),
      object: concept)
    observer?.documentChanged(withElement: concept)
  }

  @objc func save(link: Link) {
    links.append(link)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.remove(link:)),
      object: link)
    observer?.documentChanged(withElement: link)
  }

  @objc func remove(link: Link) {
    links.remove(at: links.index(of: link)!)
    undoManager?.registerUndo(
      withTarget: self,
      selector: #selector(Document.save(link:)),
      object: link)
    observer?.documentChanged(withElement: link)
  }

  func move(concept: Concept, toPoint: CGPoint) {
    Swift.print("move concept \(concept) toPoint: \(toPoint)")
    let originalPoint = concept.centerPoint
    concept.centerPoint = toPoint
    observer?.documentChanged(withElement: concept)

    undoManager?.registerUndo(withTarget: self, handler: { (object) in
      object.move(concept: concept, toPoint: originalPoint)
    })
  }

}

extension Document: CanvasViewDataSource {
  public func drawableElements(forRect: CGRect) -> [DrawableElement] {
    return drawableElements
  }

  public var drawableElements: [DrawableElement] {
    var elements: [DrawableElement] = []

    elements += concepts.map {
      DrawableConcept(concept: $0) as DrawableElement
    }

    elements += links.map {
      DrawableLink(link: $0) as DrawableElement
    }

    return elements
  }
}
