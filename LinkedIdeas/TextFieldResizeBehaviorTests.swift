//
//  TextFieldResizeBehaviorTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 04/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class TextFieldResizeBehaviorTests: XCTestCase {
  let resizeBehavior = TextFieldResizingBehavior()

  override func setUp() {
    super.setUp()
  }

  func testResizeTextFieldDoesntAlterTopLeftPointPosition() {
    let originalRect = NSRect(x: 300, y: 400, width: 200, height: 50)
    let textField = NSTextField(frame: originalRect)
    textField.stringValue = "some random string that will have a certain lenght but " +
                            "wont affect top left corner position"

    assert(originalRect.topLeftPoint == NSPoint(x: 300, y: 450))

    resizeBehavior.resize(textField)

    XCTAssertEqual(originalRect.topLeftPoint, textField.frame.topLeftPoint)
  }
}
