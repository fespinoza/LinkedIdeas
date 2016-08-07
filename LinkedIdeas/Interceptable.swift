//
//  Interceptable.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 25/02/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol Interceptable {
  func interceptsWith(_ other: Self) -> Bool
}
