//
//  Color.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 06/10/2019.
//  Copyright © 2019 Felipe Espinoza Dev. All rights reserved.
//
#if os(iOS)
  import UIKit
  public typealias Color = UIColor
#else
  import AppKit
  public typealias Color = NSColor
#endif

extension Color {
  #if os(iOS)
    convenience init?(named name: String, bundle: Bundle?) {
      self.init(named: name, in: bundle, compatibleWith: nil)
    }
  #endif

  static var bakgroundColor: Color {
    #if os(iOS)
      if #available(iOS 13.0, *) {
        return Color.systemBackground
      } else {
        return Color.white
      }
    #else
      return Color.windowBackgroundColor
    #endif
  }

  /// converts a given color to the same color space and does some simplified math in order to see
  /// if the colors are close enought to be considered the same
  func isClose(to otherColor: Color) -> Bool {
    #if os(iOS)
      return true
    #else
    guard let otherColor = otherColor.usingColorSpace(.deviceRGB),
        let rgbColor = self.usingColorSpace(.deviceRGB) else {
      return false
    }

    return floor(rgbColor.redComponent * 255) == floor(otherColor.redComponent * 255) &&
      floor(rgbColor.greenComponent * 255) == floor(otherColor.greenComponent * 255) &&
      floor(rgbColor.blueComponent * 255) == floor(otherColor.blueComponent * 255) &&
      floor(rgbColor.alphaComponent * 255) == floor(otherColor.alphaComponent * 255)
    #endif
  }
}
