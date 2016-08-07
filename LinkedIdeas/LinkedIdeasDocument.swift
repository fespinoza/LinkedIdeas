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
  
  func saveConcept(_ concept: Concept)
  func removeConcept(_ concept: Concept)
  
  func saveLink(_ link: Link)
  func removeLink(_ link: Link)
  
  func changeConceptPoint(_ concept: Concept, fromPoint: NSPoint, toPoint: NSPoint)
}
