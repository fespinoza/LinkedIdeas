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
    let boldFont = NSFontManager.sharedFontManager()
      .convertFont(
        NSFont(name: "Helvetica", size: 18)!,
        toHaveTrait: .BoldFontMask
    )
    let boldText = NSAttributedString(
      string: stringValue,
      attributes: [NSFontAttributeName: boldFont]
    )
    
    XCTAssert(boldText.isBold)
  }
  
  func testIsBoldWhenItIsNot() {
    let boldFont = NSFontManager.sharedFontManager()
      .convertFont(
        NSFont(name: "Helvetica", size: 18)!,
        toNotHaveTrait: .BoldFontMask
    )
    let text = NSAttributedString(
      string: stringValue,
      attributes: [NSFontAttributeName: boldFont]
    )
    
    XCTAssertFalse(text.isBold)
  }
  
  // isStrikedThrough
  func testIsStrikedThroughWhenItIs() {
    let stringValue = "This is awesome"
    let attributedString = NSAttributedString(
      string: stringValue,
      attributes: [
        NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
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
      attributes: [NSForegroundColorAttributeName: NSColor.redColor()]
    )
    
    XCTAssertEqual(coloredText.fontColor!, NSColor.redColor())
  }
  
  // fontSize
  func testFontSize() {
    let attributedString = NSAttributedString(
      string: stringValue,
      attributes: [NSFontAttributeName: NSFont(name: "Helvetica", size: 18)!]
    )
    
    XCTAssertEqual(attributedString.fontSize, 18)
  }
  
  // NSAttributedString(attributedString:strikeThrough:)
  func testCreatingAStrikedThroughString() {
    let attributedString = NSAttributedString(string: stringValue)
    let newAttributedString = NSAttributedString(
      attributedString: attributedString,
      strikeThrough: true
    )
    
    XCTAssert(newAttributedString.isStrikedThrough)
  }
  
  func testCreatingANotStrikedThroughString() {
    let attributedString = NSAttributedString(
      string: stringValue,
      attributes: [
        NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
      ]
    )
    let newAttributedString = NSAttributedString(
      attributedString: attributedString,
      strikeThrough: false
    )
    
    XCTAssertEqual(newAttributedString.isStrikedThrough, false)
  }
  
  // NSAttributedString(attributedString:bold:)
  func testCreatingABoldString() {
    let newAttributedString = NSAttributedString(
      attributedString: NSAttributedString(string: stringValue),
      bold: true
    )
    
    XCTAssert(newAttributedString.isBold)
  }
  
  // NSAttributedString(attributedString:withColor:NSColor)
  func testCreatingAFontWithColor() {
    let newAttributedString = NSAttributedString(
      attributedString: NSAttributedString(string: stringValue),
      fontColor: NSColor.redColor()
    )
    
    XCTAssertEqual(newAttributedString.fontColor!, NSColor.redColor())
  }
  
  // NSAttributedString(attributedString:withFontSize:Int)
  func testCreatingAStringWithGivenFontSize() {
    let newAttributedString = NSAttributedString(
      attributedString: NSAttributedString(string: stringValue),
      fontSize: 20
    )
    
    XCTAssertEqual(newAttributedString.fontSize, 20)
  }
}
