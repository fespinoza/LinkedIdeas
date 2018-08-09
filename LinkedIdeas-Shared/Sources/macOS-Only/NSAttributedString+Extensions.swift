//
//  NSAttributedStringExtensions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 03/07/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
public typealias Font = NSFont

public extension String {
  static let codeFontName = "Monaco"
}

public extension NSAttributedString {
  // MARK: - Computed Properties
  public var maxRange: NSRange { return NSRange(location: 0, length: length) }

  public var isStrikedThrough: Bool {
    var range = maxRange
    let strikeValue = attribute(NSAttributedStringKey.strikethroughStyle, at: 0, effectiveRange: &range) as? Int
    return strikeValue == NSUnderlineStyle.styleSingle.rawValue
  }

  public var isBold: Bool {
    return font.fontDescriptor.symbolicTraits.contains(.bold)
  }

  public var defaultFont: Font { return Font(name: "Helvetica", size: 12)! }

  public var font: Font {
    var range = maxRange
    let _font = attribute(NSAttributedStringKey.font, at: 0, effectiveRange: &range) as? Font
    if let _font = _font {
      return _font
    } else {
      return defaultFont
    }
  }

  public var fontSize: Int { return Int(font.pointSize) }

  public var fontColor: Color {
    var range = maxRange
    let color = attribute(NSAttributedStringKey.foregroundColor, at: 0, effectiveRange: &range) as? Color
    if let color = color {
      return color
    } else {
      return Color.black
    }
  }

  // MARK: - Convenience Initializers
  public convenience init(attributedString: NSAttributedString, strikeThrough: Bool) {
    var strikeStyle: NSUnderlineStyle = NSUnderlineStyle.styleNone
    if strikeThrough { strikeStyle = NSUnderlineStyle.styleSingle }

    if let _tempCopy = attributedString.mutableCopy() as? NSMutableAttributedString {
      _tempCopy.addAttribute(
        NSAttributedStringKey.strikethroughStyle,
        value: strikeStyle.rawValue,
        range: attributedString.maxRange
      )
      self.init(attributedString: _tempCopy as NSAttributedString)
    } else {
      self.init(attributedString: attributedString)
    }
  }

  public convenience init(attributedString: NSAttributedString, bold: Bool) {
    var newFont: Font!

    if bold {
      newFont = NSFontManager.shared.convert(attributedString.font, toHaveTrait: .boldFontMask)
    } else {
      newFont = NSFontManager.shared.convert(attributedString.font, toNotHaveTrait: .boldFontMask)
    }

    if let _tempCopy = attributedString.mutableCopy() as? NSMutableAttributedString {
      _tempCopy.addAttribute(NSAttributedStringKey.font, value: newFont, range: attributedString.maxRange)

      self.init(attributedString: _tempCopy as NSAttributedString)
    } else {
      self.init(attributedString: attributedString)
    }
  }

  public convenience init(attributedString: NSAttributedString, fontName: String) {
    if let _tempCopy = attributedString.mutableCopy() as? NSMutableAttributedString {
      let newFont = NSFont(name: fontName, size: CGFloat(attributedString.fontSize))!
      _tempCopy.addAttribute(.font, value: newFont, range: attributedString.maxRange)

      self.init(attributedString: _tempCopy as NSAttributedString)
    } else {
      self.init(attributedString: attributedString)
    }
  }

  public convenience init(attributedString: NSAttributedString, fontColor: Color) {
    if let _tempCopy = attributedString.mutableCopy() as? NSMutableAttributedString {
      _tempCopy.addAttribute(NSAttributedStringKey.foregroundColor, value: fontColor, range: attributedString.maxRange)

      self.init(attributedString: _tempCopy as NSAttributedString)
    } else {
      self.init(attributedString: attributedString)
    }
  }

  public convenience init(attributedString: NSAttributedString, fontSize: Int) {
    let newFont: Font = NSFontManager.shared.convert(
      attributedString.font, toSize: CGFloat(fontSize))
    if let _tempCopy = attributedString.mutableCopy() as? NSMutableAttributedString {
      _tempCopy.addAttribute(NSAttributedStringKey.font, value: newFont, range: attributedString.maxRange)

      self.init(attributedString: _tempCopy as NSAttributedString)
    } else {
      self.init(attributedString: attributedString)
    }
  }
}
