//
//  Handler.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/08/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

public struct Handler {
  enum Position {
    case left
    case right
  }

  weak var concept: Concept?
  var centerPoint: CGPoint {
    guard let concept = self.concept else {
      preconditionFailure("concept was released before hand")
    }
    switch position {
    case .left:
      return concept.area.middleLeftPoint
    case .right:
      return concept.area.middleRightPoint
    }
  }

  var area: CGRect {
    return CGRect(center: centerPoint, size: size)
  }

  let size: CGSize
  let position: Position
  let length = 6

  init(concept: Concept, position: Position) {
    self.concept = concept
    self.position = position
    self.size = CGSize(width: length, height: length)
  }

  func draw() {
    NSColor.white.set()
    area.fill()
    NSColor.black.set()
    NSBezierPath(rect: area).stroke()
  }

  func contains(_ point: CGPoint) -> Bool {
    return area.contains(point)
  }
}
