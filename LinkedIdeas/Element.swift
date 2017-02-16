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
  var rect: NSRect { get }

  // center point of element
  var point: NSPoint { get }

  var attributedStringValue: NSAttributedString { get  set }

  var isEditable: Bool { get set }
  var isSelected: Bool { get set }
}

protocol AttributedStringElement {
  var attributedStringValue: NSAttributedString { get  set }
  var stringValue: String { get }
}

protocol VisualElement {
  var isEditable: Bool { get set }
  var isSelected: Bool { get set }
}
