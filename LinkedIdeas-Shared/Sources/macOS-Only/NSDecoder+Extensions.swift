//
//  NSDecoder+Extensions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 03/02/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

extension NSCoder {
  func decodeCGPoint(forKey key: String) -> CGPoint {
    return self.decodePoint(forKey: key) as CGPoint
  }
}
