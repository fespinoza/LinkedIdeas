//
//  ColorUtils.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 28/07/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct ColorUtils {
  static func extractColorComponents(forColor color: NSColor) -> [CGFloat] {
    guard let rgbColor = color.usingColorSpace(.genericRGB) else {
      preconditionFailure("I should have to be able to get an RGB color for the given one")
    }
    return [rgbColor.redComponent, rgbColor.greenComponent, rgbColor.blueComponent, rgbColor.alphaComponent]
  }

  static func color(fromComponents colorComponents: [CGFloat]) -> NSColor {
    // what if the components are not correct?
    return NSColor(
      red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: colorComponents[3]
    )
  }
}
