//
//  Handler.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/08/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//
import CoreGraphics

public struct Handler {
  public enum Position {
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
  public let position: Position
  let length = 6

  public init(concept: Concept, position: Position) {
    self.concept = concept
    self.position = position
    self.size = CGSize(width: length, height: length)
  }

  func draw() {
    Color.white.set()
    area.fill()
    Color.black.set()
    BezierPath(rect: area).stroke()
  }

  public func contains(_ point: CGPoint) -> Bool {
    return area.contains(point)
  }
}
