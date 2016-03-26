//
//  Element.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol Element {
  var identifier: String { get }
  var minimalRect: NSRect { get }
}

protocol StringElement {
  var stringValue: String { get  set }
}

protocol VisualElement {
  var isEditable: Bool { get set }
  var isSelected: Bool { get set }
}