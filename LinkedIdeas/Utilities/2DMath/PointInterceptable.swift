//
//  PointInterceptable.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol PointInterceptable {
  func intersectionPointWith(_ other: Self) -> NSPoint?
}
