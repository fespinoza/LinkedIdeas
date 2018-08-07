//
//  ColorUtils.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 28/07/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

#if os(iOS)
  import UIKit

  extension UIColor {
    func getColorRGBComponents() -> [CGFloat] {
      var redComponent: CGFloat = 0
      var greenComponent: CGFloat = 0
      var blueComponent: CGFloat = 0
      var alphaComponent: CGFloat = 0

      getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)

      return [redComponent, greenComponent, blueComponent, alphaComponent]
    }
  }
#else
  import AppKit

  extension NSColor {
    func getColorRGBComponents() -> [CGFloat] {
      guard let rgbColor = self.usingColorSpace(.genericRGB) else {
        preconditionFailure("I should have to be able to get an RGB color for the given one")
      }

      return [rgbColor.redComponent, rgbColor.greenComponent, rgbColor.blueComponent, rgbColor.alphaComponent]
    }
  }
#endif

struct ColorUtils {
  static func extractColorComponents(forColor color: Color) -> [CGFloat] {
    return color.getColorRGBComponents()
  }

  static func color(fromComponents colorComponents: [CGFloat]) -> Color {
    return Color(
      red: colorComponents[0], green: colorComponents[1], blue: colorComponents[2], alpha: colorComponents[3]
    )
  }
}
