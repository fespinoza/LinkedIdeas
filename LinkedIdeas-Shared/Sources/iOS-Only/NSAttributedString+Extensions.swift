//
//  NSAttributedString+Extensions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 06/10/2019.
//  Copyright © 2019 Felipe Espinoza Dev. All rights reserved.
//

import UIKit

public extension NSAttributedString {
  // MARK: - Computed Properties
  var maxRange: NSRange { return NSRange(location: 0, length: length) }

  var fontColor: Color {
    var range = NSRange(location: 0, length: length)
    let color = attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: &range) as? Color
    if let color = color {
      return color
    } else {
      return Color.black
    }
  }

  convenience init(attributedString: NSAttributedString, fontColor: Color) {
    if let _tempCopy = attributedString.mutableCopy() as? NSMutableAttributedString {
      _tempCopy.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: attributedString.maxRange)

      self.init(attributedString: _tempCopy as NSAttributedString)
    } else {
      self.init(attributedString: attributedString)
    }
  }
}
