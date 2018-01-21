//
//  File.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

public protocol GraphConcept {
  var area: CGRect { get }
  var centerPoint: CGPoint { get }
  var stringValue: String { get }
  var attributedStringValue: NSAttributedString { get }
  var isSelected: Bool { get set }
  var isEditable: Bool { get set }

  var leftHandler: Handler? { get }
  var rightHandler: Handler? { get }

  func draw()
}

public protocol GraphLink {
  var color: NSColor { get }
  var isSelected: Bool { get set }

  var stringValue: String { get }
  var attributedStringValue: NSAttributedString { get }

  var centerPoint: CGPoint { get }
  var area: CGRect { get }

  var originPoint: CGPoint { get }
  var targetPoint: CGPoint { get }

  var originRect: CGRect { get }
  var targetRect: CGRect { get }
}

extension Concept: GraphConcept {}

extension Link: GraphLink {
  public var originRect: CGRect { return origin.area }
  public var targetRect: CGRect { return target.area }
}
