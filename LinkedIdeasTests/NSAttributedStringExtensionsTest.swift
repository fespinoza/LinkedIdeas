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
  func testFontColor() {}
  
  // fontSize
  func testFontSize() {}
  
  // maxRange
  func testMaxRange() {}
  
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
  
  // NSAttributedString(attributedString:bold:Bool)
  func testCreatingABoldString() {
    let newAttributedString = NSAttributedString(
      attributedString: NSAttributedString(string: stringValue),
      bold: true
    )
    
    XCTAssert(newAttributedString.isBold)
  }
  
  // NSAttributedString(attributedString:strikeThrough:Bool)
  // NSAttributedString(attributedString:bold:Bool)
  // NSAttributedString(attributedString:withColor:NSColor)
  // NSAttributedString(attributedString:withFontSize:Int)
}
