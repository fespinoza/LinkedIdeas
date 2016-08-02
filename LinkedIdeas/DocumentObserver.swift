//
//  DocumentObserver.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol DocumentObserver {
  func conceptAdded(_ concept: Concept)
  func conceptRemoved(_ concept: Concept)
  func conceptUpdated(_ concept: Concept)
  
  func linkAdded(_ link: Link)
  func linkRemoved(_ link: Link)
  func linkUpdated(_ link: Link)
}
