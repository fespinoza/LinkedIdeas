//
//  LinkedIdeasDocument.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation
import LinkedIdeas_Shared

protocol LinkedIdeasDocument {
  var concepts: [Concept] { get }
  var links: [Link] { get }

  var observer: DocumentObserver? { get set }

  func save(concept: Concept)
  func save(concepts: [Concept])
  func remove(concept: Concept)
  func remove(concepts: [Concept])

  func save(link: Link)
  func remove(link: Link)

  func move(concept: Concept, toPoint: CGPoint)
}
