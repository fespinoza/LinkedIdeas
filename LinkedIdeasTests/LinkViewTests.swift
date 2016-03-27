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
  let canvas = CanvasView(frame: NSMakeRect(20, 20, 600, 400))
  let concept1 = Concept(stringValue: "foo", point: NSMakePoint(100, 200))
  let concept2 = Concept(stringValue: "bar", point: NSMakePoint(300, 300))
  
  func testCreateALinkView() {
    // given
    let link = Link(origin: concept1, target: concept2)
    
    // when
    let linkView = LinkView(link: link, canvas: canvas)
    
    // then
    XCTAssertEqual(linkView.frame, link.minimalRect)
  }
  
  func testLinkViewDrawingProportions() {
    // given
    canvas.concepts = [concept1, concept2]
    canvas.drawConceptViews()
    let conceptView1 = canvas.conceptViewFor(concept1)
    let conceptView2 = canvas.conceptViewFor(concept2)
    let link = Link(origin: concept1, target: concept2)
    let linkView = LinkView(link: link, canvas: canvas)
    let concept1PointInLinkViewCoordinates = NSMakePoint(40, 30)
    let concept2PointInLinkViewCoordinates = NSMakePoint(200, 110)
    
    // when
    let arrow = linkView.constructArrow()
    
    // then
    let linkViewBoundsInCanvasCoordinates = canvas.convertRect(linkView.bounds, toView: nil)
    XCTAssertEqual(linkView.bounds, NSMakeRect(0, 0, 200, 100))
    XCTAssertEqual(arrow.p1, concept1PointInLinkViewCoordinates)
    XCTAssertEqual(arrow.p2, concept2PointInLinkViewCoordinates)
    XCTAssert(CGRectContainsPoint(linkViewBoundsInCanvasCoordinates, arrow.p1))
    XCTAssert(CGRectContainsPoint(linkViewBoundsInCanvasCoordinates, arrow.p2))
  }
  
}