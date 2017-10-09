//
//  NSAttributedStringExtensionsTest.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 29/06/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class NSAttributedStringExtensionsTest: XCTestCase {
  let stringValue = "This is awesome"

  // isBold
  func testIsBoldWhenItIs() {
    let boldFont = NSFontManager.shared
      .convert(
        NSFont(name: "Helvetica", size: 18)!,
        toHaveTrait: .boldFontMask
    )
    let boldText = NSAttributedString(
      string: stringValue,
      attributes: [NSAttributedStringKey.font: boldFont]
    )

    XCTAssert(boldText.isBold)
  }

  func testIsBoldWhenItIsNot() {
    let boldFont = NSFontManager.shared
      .convert(
        NSFont(name: "Helvetica", size: 18)!,
        toNotHaveTrait: .boldFontMask
    )
    let text = NSAttributedString(
      string: stringValue,
      attributes: [NSAttributedStringKey.font: boldFont]
    )

    XCTAssertFalse(text.isBold)
  }

  // isStrikedThrough
  func testIsStrikedThroughWhenItIs() {
    let stringValue = "This is awesome"
    let attributedString = NSAttributedString(
      string: stringValue,
      attributes: [
        NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
      ]
    )

    XCTAssertEqual(attributedString.isStrikedThrough, true)
  }

  func testIsStrikedThroughWhenItIsNot() {

    let attributedString = NSAttributedString(string: stringValue)

    XCTAssertEqual(attributedString.isStrikedThrough, false)
  }

  // fontColor
  func testFontColor() {
    let coloredText = NSAttributedString(
      string: stringValue,
      attributes: [NSAttributedStringKey.foregroundColor: NSColor.red]
    )

    XCTAssertEqual(coloredText.fontColor, NSColor.red)
  }

  // fontSize
  func testFontSize() {
    let attributedString = NSAttributedString(
      string: stringValue,
      attributes: [NSAttributedStringKey.font: NSFont(name: "Helvetica", size: 18)!]
    )

    XCTAssertEqual(attributedString.fontSize, 18)
  }

  // NSAttributedString(attributedString:strikeThrough:)
  func testCreatingAStrikedThroughString() {
    let attributedString = NSAttributedString(string: stringValue)
    let neNSAttributedString = NSAttributedString(
      attributedString: attributedString,
      strikeThrough: true
    )

    XCTAssert(neNSAttributedString.isStrikedThrough)
  }

  func testCreatingANotStrikedThroughString() {
    let attributedString = NSAttributedString(
      string: stringValue,
      attributes: [
        NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue
      ]
    )
    let neNSAttributedString = NSAttributedString(
      attributedString: attributedString,
      strikeThrough: false
    )

    XCTAssertEqual(neNSAttributedString.isStrikedThrough, false)
  }

  // NSAttributedString(attributedString:bold:)
  func testCreatingABoldString() {
    let neNSAttributedString = NSAttributedString(
      attributedString: NSAttributedString(string: stringValue),
      bold: true
    )

    XCTAssert(neNSAttributedString.isBold)
  }

  // NSAttributedString(attributedString:withColor:NSColor)
  func testCreatingAFontWithColor() {
    let neNSAttributedString = NSAttributedString(
      attributedString: NSAttributedString(string: stringValue),
      fontColor: NSColor.red
    )

    XCTAssertEqual(neNSAttributedString.fontColor, NSColor.red)
  }

  // NSAttributedString(attributedString:withFontSize:Int)
  func testCreatingAStringWithGivenFontSize() {
    let neNSAttributedString = NSAttributedString(
      attributedString: NSAttributedString(string: stringValue),
      fontSize: 20
    )

    XCTAssertEqual(neNSAttributedString.fontSize, 20)
  }
}
