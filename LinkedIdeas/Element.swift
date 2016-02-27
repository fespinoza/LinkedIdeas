//
//  Element.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 30/01/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

protocol Editable {
  var editing: Bool { get set }
}

protocol Identifiable {
  var identifier: String { get }
}


class Element: Editable {
  var editing: Bool = false
}