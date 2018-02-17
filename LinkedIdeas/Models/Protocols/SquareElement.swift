//
//  SquareElement.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/05/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol SquareElement: class {
  var centerPoint: CGPoint { get set }
  var area: CGRect { get }
}
