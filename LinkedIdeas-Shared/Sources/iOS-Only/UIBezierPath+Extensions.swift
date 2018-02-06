//
//  UIBezierPath+Extensions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 06/02/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit

extension UIBezierPath {
  func line(to point: CGPoint) {
    self.addLine(to: point)
  }
}
