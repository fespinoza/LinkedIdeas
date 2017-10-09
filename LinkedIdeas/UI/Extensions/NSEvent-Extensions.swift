//
//  NSEvent-Extensions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 16/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSEvent {
  func isSingleClick() -> Bool { return clickCount == 1 }
  func isDoubleClick() -> Bool { return clickCount == 2 }
}
