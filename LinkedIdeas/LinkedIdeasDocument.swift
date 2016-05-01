//
//  LinkedIdeasDocument.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol LinkedIdeasDocument {
  var concepts: [Concept] { get }
  var links: [Link] { get }
  
  var observer: DocumentObserver? { get set }
  
  func saveConcept(concept: Concept)
  func removeConcept(concept: Concept)
  
  func saveLink(link: Link)
  func removeLink(link: Link)
  
  func changeConceptPoint(concept: Concept, fromPoint: NSPoint, toPoint: NSPoint)
}