//
//  DocumentObserver.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol DocumentObserver {
  func conceptAdded(concept: Concept)
  func conceptRemoved(concept: Concept)
  func conceptUpdated(concept: Concept)
  
  func linkAdded(link: Link)
  func linkRemoved(link: Link)
  func linkUpdated(link: Link)
}