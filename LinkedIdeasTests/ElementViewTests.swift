//
//  ElementView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 30/01/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class ElementViewTests: XCTestCase {
  
  var canvasView: CanvasView!
  var element: Element!
  var frame: NSRect!
  
  override func setUp() {
    super.setUp()
    
    element = Element()
    canvasView = CanvasView()
    frame = NSMakeRect(0, 0, 100, 50)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testWhenElementIsBeingEditingTextFieldIsActive() {
    // given
    element.editing = true
    let elementView = ElementView(frame: frame, element: element, canvas: canvasView)
    
    // when
    elementView.drawRect(frame)
    
    // then
    XCTAssertTrue(elementView.textField.editable)
    XCTAssertFalse(elementView.textField.hidden)
  }
  
  func testWhenElementIsNotBeingEditedTextFieldIsHiddenAndRenderElementsStringValue() {
    // given
    element.editing = false
    let elementView = ElementView(frame: frame, element: element, canvas: canvasView)
    
    // when
    elementView.drawRect(frame)
    
    // then
    XCTAssertFalse(elementView.textField.editable)
    XCTAssertTrue(elementView.textField.hidden)
  }
  
  func testClickOnElementViewSelectsIt() {
    // given
    let elementView = ElementView(frame: frame, element: element, canvas: canvasView)
    elementView.drawRect(frame)
    
    // when
    elementView.mouseDown(NSEvent())
    
    // then
    XCTFail("implement me")
  }
  
  func testDoubleClickOnElementViewMakesItEditable() {
    let elementView = ElementView(frame: frame, element: element, canvas: canvasView)
    elementView.drawRect(frame)
    
    // when
    let doubleClickEvent = NSEvent.mouseEventWithType(
      .LeftMouseDown,
      location: NSMakePoint(0, 0),
      modifierFlags: NSEventModifierFlags.AlphaShiftKeyMask,
      timestamp: NSTimeInterval(),
      windowNumber: 0,
      context: nil,
      eventNumber: 0,
      clickCount: 2,
      pressure: 0.0
    )
    if let doubleClickEvent = doubleClickEvent {
      // when
      elementView.mouseDown(doubleClickEvent)
      
      // then
      XCTAssertTrue(elementView.element.editing)
    } else {
      XCTFail("unable to create double click event")
    }
  }
  
  func testWhenEditingPressingEnterWillMakeItNotEditable() {
    // given
    element.editing = true
    let elementView = ElementView(frame: frame, element: element, canvas: canvasView)
    let textField = elementView.textField
    elementView.drawRect(frame)
    
    textField.becomeFirstResponder()
    textField.keyDown(<#T##theEvent: NSEvent##NSEvent#>)
    
  }
  
  func testWhenSelectedPressingDeleteWillRemoveTheElementView() {
    XCTFail("implement me")
  }
}