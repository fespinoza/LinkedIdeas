//
//  File.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol GraphConcept {
  var rect: NSRect { get }
  var attributedStringValue: NSAttributedString { get }
  var isSelected: Bool { get set }
}

protocol GraphLink {
  var color: NSColor { get }
  var isSelected: Bool { get set }

  var stringValue: String { get }
  var attributedStringValue: NSAttributedString { get }

  var point: NSPoint { get }

  var originPoint: NSPoint { get }
  var targetPoint: NSPoint { get }

  var originRect: NSRect { get }
  var targetRect: NSRect { get }
}

extension Concept: GraphConcept {}

extension Link: GraphLink {
  var originRect: NSRect { return origin.rect }
  var targetRect: NSRect { return target.rect }
}
