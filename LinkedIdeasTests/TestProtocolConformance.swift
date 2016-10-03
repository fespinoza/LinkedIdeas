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
  var observer: DocumentObserver? = nil
  
  func save(concept: Concept) {
    concepts.append(concept)
  }
  func remove(concept: Concept) {}
  
  func save(link: Link) {}
  func remove(link: Link) {}
  
  func move(concept: Concept, toPoint: NSPoint) {}
}

class StateManagerTestDelegate {
  var methodCalls = [String: Int]()
  
  func registerCall(methodName: String) {
    if let currentCallsNumber = methodCalls[methodName] {
      methodCalls[methodName] = currentCallsNumber + 1
    } else {
      methodCalls[methodName] = 1
    }
  }
}

extension StateManagerTestDelegate: StateManagerDelegate {
  func unselectAllElements() {
    registerCall(methodName: #function)
  }
  
  // concepts
  func cancelConceptCreation() {
    registerCall(methodName: #function)
  }
  
  func saveConcept(text: NSAttributedString, atPoint: NSPoint) -> Bool {
    registerCall(methodName: #function)
    return true
  }
  
  // text field
  func showTextField(atPoint: NSPoint) {
    registerCall(methodName: #function)
  }
  
  func dismissTextField() {
    registerCall(methodName: #function)
  }
}

struct TestElement: Element {
  var identifier: String
  var rect: NSRect
  var isSelected: Bool = false
  var isEditable: Bool = false
  
  static let sample = TestElement(
    identifier: "element #1",
    rect: NSMakeRect(30, 40, 100, 50),
    isSelected: false,
    isEditable: false
  )
}
