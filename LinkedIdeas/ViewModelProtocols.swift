//
//  File.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

public protocol GraphConcept {
  var area: NSRect { get }
  var centerPoint: NSPoint { get }
  var stringValue: String { get }
  var attributedStringValue: NSAttributedString { get }
  var isSelected: Bool { get set }
  var isEditable: Bool { get set }
}

public protocol GraphLink {
  var color: NSColor { get }
  var isSelected: Bool { get set }

  var stringValue: String { get }
  var attributedStringValue: NSAttributedString { get }

  var centerPoint: NSPoint { get }
  var area: NSRect { get }

  var originPoint: NSPoint { get }
  var targetPoint: NSPoint { get }

  var originRect: NSRect { get }
  var targetRect: NSRect { get }
}

extension Concept: GraphConcept {}

extension Link: GraphLink {
  public var originRect: NSRect { return origin.area }
  public var targetRect: NSRect { return target.area }
}
