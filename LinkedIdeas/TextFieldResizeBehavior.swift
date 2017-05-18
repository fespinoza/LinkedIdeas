//
//  TextFieldResizeBehavior.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 27/04/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct TextFieldResizingBehavior {
  let maxHeight: CGFloat = 100000.0
  let maxWidthPadding: CGFloat = 10
  let minWidth: CGFloat = 50
  let maxWidth: CGFloat = 250

  func resize(_ textField: NSTextField) {
    let originalFrame = textField.frame

    var textMaxWidth = textField.attributedStringValue.size().width
    textMaxWidth = textMaxWidth > maxWidth ? maxWidth : textMaxWidth
    textMaxWidth += maxWidthPadding

    var constraintBounds: NSRect = textField.frame
    constraintBounds.size.width = textMaxWidth
    constraintBounds.size.height = maxHeight

    var naturalSize = textField.cell!.cellSize(forBounds: constraintBounds)

    // ensure minimun size of text field
    naturalSize.width = naturalSize.width < minWidth ? minWidth : naturalSize.width

    if originalFrame.height != naturalSize.height {
      // correct the origin in order the textField to grow down.
      let yOffset: CGFloat = naturalSize.height - originalFrame.height
      let newOrigin = NSPoint(
        x: originalFrame.origin.x,
        y: originalFrame.origin.y - yOffset
      )
      textField.setFrameOrigin(newOrigin)
    }

    textField.setFrameSize(naturalSize)

  }

  func setFrame(toTextField textField: NSTextField, forContentRect contentRect: NSRect) {
    let frameOrigin = NSPoint(
      x: contentRect.origin.x - 5,
      y: contentRect.origin.y - 3
    )
    let frameSize = NSSize(
      width: contentRect.width + 5,
      height: contentRect.height + 5
    )
    let frame = NSRect(origin: frameOrigin, size: frameSize)

    textField.frame = frame
  }
}
