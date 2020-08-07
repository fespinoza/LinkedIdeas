//
//  File.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 27/09/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation
@testable import LinkedIdeas
@testable import LinkedIdeas_Shared

class TestLinkedIdeasDocument: LinkedIdeasDocument {
  var concepts = [Concept]()
  var links = [Link]()
  var observer: DocumentObserver?

  func save(concept: Concept) {
    concepts.append(concept)
  }
  
  func save(concepts newConcepts: [Concept]) {
    concepts.append(contentsOf: newConcepts)
  }
  
  func remove(concepts: [Concept]) {}
  func remove(concept: Concept) {}

  func save(link: Link) {}
  func remove(link: Link) {}

  func move(concept: Concept, toPoint: CGPoint) {}
}

protocol MockMethodCalls: class {
  var methodCalls: [String: Int] { get set }
}

extension MockMethodCalls {
  func registerCall(methodName: String) {
    if let currentCallsNumber = methodCalls[methodName] {
      methodCalls[methodName] = currentCallsNumber + 1
    } else {
      methodCalls[methodName] = 1
    }
  }
}

class StateManagerTestDelegate: MockMethodCalls {
  var methodCalls = [String: Int]()
}

extension StateManagerTestDelegate: StateManagerDelegate {
  func transitionedToSelectedElementDuplicatingConcept(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToResizingConcept(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionSuccesfull() {}

  func transitionedToNewConcept(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToCanvasWaiting(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: CGPoint, text: NSAttributedString) {
    registerCall(methodName: #function)
  }

  func transitionedToSelectedElement(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToSelectedElementSavingChanges(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToEditingElement(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToMultipleSelectedElements(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToCanvasWaitingDeletingElements(fromState: CanvasState) {
    registerCall(methodName: #function)
  }
}

struct TestElement: Element {
  var stringValue: String { return attributedStringValue.string }
  var identifier: String
  var area: CGRect
  var isSelected: Bool = false
  var isEditable: Bool = false
  var centerPoint: CGPoint { return area.center }
  var attributedStringValue: NSAttributedString
  var debugDescription: String {
    return "[Concept][\(identifier)]"
  }

  static let sample = TestElement(
    identifier: "element #1",
    area: CGRect(x: 30, y: 40, width: 100, height: 50),
    isSelected: false,
    isEditable: false,
    attributedStringValue: NSAttributedString(string: "")
  )
}
