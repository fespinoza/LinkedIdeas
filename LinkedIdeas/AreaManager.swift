//
//  FooBar.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

protocol AreaManagerProtocol {
  func boundedRect(forAttributedString: NSAttributedString, atPoint: NSPoint) -> NSRect
}

struct AreaManager: AreaManagerProtocol {
  let defaultSize = NSSize(width: 60, height: 20)
  let constrainSize = NSSize(width: 250, height: 1000000.0)

  /// Calculates the NSRect for a NSAttributedString within constrain size.
  ///
  /// - Parameters:
  ///   - attributedString: attributed String to encapsulate in rect
  ///   - centerPoint: center point of the resulting rectangle
  /// - Returns: centered rect in centerPoint that contains the attributed string within a max width and dynamic height.
  func boundedRect(
    forAttributedString attributedString: NSAttributedString,
    atPoint centerPoint: NSPoint
    ) -> NSRect {
    return usingTextFieldBehavior(attributedString: attributedString, centerPoint: centerPoint)
  }

  // this seems to work the best
  private let textField = NSTextField()
  private let resizeBehavior = TextFieldResizingBehavior()
  private func usingTextFieldBehavior(attributedString: NSAttributedString, centerPoint: NSPoint) -> NSRect {
    let defaultRect = NSRect(center: centerPoint, size: defaultSize)

    textField.frame = defaultRect
    textField.attributedStringValue = attributedString
    resizeBehavior.resize(textField)

    return NSRect(center: centerPoint, size: textField.frame.size)
  }

  // this has problems with the height of the field
  private func usingNSLayoutManager(attributedString: NSAttributedString, centerPoint: NSPoint) -> NSRect {
    let defaultRect = NSRect(center: centerPoint, size: defaultSize)
    let stringValue = attributedString.string

    if stringValue == "" {
      return defaultRect
    } else {
      let textStorage = NSTextStorage(attributedString: attributedString)
      let layoutManager = NSLayoutManager()
      let textContainer = NSTextContainer(size: constrainSize)

      layoutManager.addTextContainer(textContainer)
      textStorage.addLayoutManager(layoutManager)

      _ = layoutManager.glyphRange(for: textContainer)
      let newRect = layoutManager.usedRect(for: textContainer)

      // the original rect uses center
      return NSRect(center: centerPoint, size: newRect.size)
    }
  }
}
