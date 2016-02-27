//
//  LinkedIdeasUITests.swift
//  LinkedIdeasUITests
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import XCTest

class LinkedIdeasUITests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    let untitledWindow = XCUIApplication().windows["Untitled"]
    let canvasLayoutArea = untitledWindow.layoutAreas["canvas"]
    canvasLayoutArea.click()
    
    let insertConcpetTextField = untitledWindow.textFields["Insert Concpet"]
    insertConcpetTextField.typeText("fooo\r")
    canvasLayoutArea.click()
    untitledWindow.textFields["Insert Concpet"].typeText("bar\r")
    untitledWindow.layoutItems["AConceptView 1804289383"].click()
    insertConcpetTextField.click()
    insertConcpetTextField.typeText(" 2\r")
    
  }
  
  
  func testAddingAConcept() {
    let app = XCUIApplication()
    
    let window = app.windows["Untitled"]
    window.click()
    
    let canvas = window.layoutAreas["canvas"]
    canvas.click()
    window.textFields["Insert Concept"].typeText("foo\r")
    
    XCTAssert(canvas.layoutItems["AConceptView-foo"].exists)
  }
  
  func testEditingAConcept() {
    let app = XCUIApplication()
    
    let window = app.windows["Untitled"]
    window.click()
    
    let canvas = window.layoutAreas["canvas"]
    canvas.click()
    window.textFields["Insert Concept"].typeText("foo\r")
    
    canvas.layoutItems["AConceptView-foo"].doubleClick()
    window.textFields["foo"].typeText("bar\r")
    
    XCTAssertTrue(canvas.layoutItems["AConceptView-foobar"].exists)
    XCTAssertFalse(canvas.layoutItems["AConceptView-foo"].exists)
  }
  
  
}
