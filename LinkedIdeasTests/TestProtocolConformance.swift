//
//  File.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 27/09/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation
@testable import LinkedIdeas

class TestLinkedIdeasDocument: LinkedIdeasDocument {
  var concepts = [Concept]()
  var links = [Link]()
  var observer: DocumentObserver?

  func save(concept: Concept) {
    concepts.append(concept)
  }
  func remove(concept: Concept) {}

  func save(link: Link) {}
  func remove(link: Link) {}

  func move(concept: Concept, toPoint: NSPoint) {}
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
  func transitionSuccesfull() {}

  func transitionedToNewConcept(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToCanvasWaiting(fromState: CanvasState) {
    registerCall(methodName: #function)
  }

  func transitionedToCanvasWaitingSavingConcept(fromState: CanvasState, point: NSPoint, text: NSAttributedString) {
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
  var identifier: String
  var rect: NSRect
  var isSelected: Bool = false
  var isEditable: Bool = false
  var point: NSPoint { return rect.center }
  var attributedStringValue: NSAttributedString

  static let sample = TestElement(
    identifier: "element #1",
    rect: NSRect(x: 30, y: 40, width: 100, height: 50),
    isSelected: false,
    isEditable: false,
    attributedStringValue: NSAttributedString(string: "")
  )
}
