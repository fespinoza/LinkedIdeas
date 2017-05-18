//
//  DocumentObserver.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//
import Foundation

protocol DocumentObserver {
  func documentChanged(withElement element: Element)
}
