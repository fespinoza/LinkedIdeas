//
//  LinkViewTests.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 26/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import XCTest
@testable import LinkedIdeas

class LinkViewTests: XCTestCase {
  
  func testCreateALinkView() {
    // given
    let canvas = CanvasView(frame: NSMakeRect(0, 0, 600, 400))
    let concept1 = Concept(stringValue: "foo", point: NSMakePoint(100, 200))
    let concept2 = Concept(stringValue: "bar", point: NSMakePoint(300, 300))
    let link = Link(origin: concept1, target: concept2)
    
    // when
    let linkView = LinkView(link: link, canvas: canvas)
    
    // then
    XCTAssertEqual(linkView.frame, link.minimalRect)
  }
  
}