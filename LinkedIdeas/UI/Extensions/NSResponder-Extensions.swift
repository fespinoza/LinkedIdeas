//
//  NSResponder-Extensions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSResponder {
  var identifierString: String {
    return "\(type(of: self))"
  }

  func print(_ message: String) {
    Swift.print("\(identifierString): \(message)")
  }
}
