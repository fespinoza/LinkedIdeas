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
  let testDocument = TestDocument()
  let concept1 = Concept(point: NSMakePoint(100, 200))
  let concept2 = Concept(point: NSMakePoint(300, 300))
  
  override func setUp() {
    canvas.document = testDocument
    testDocument.saveConcept(concept1)
    testDocument.saveConcept(concept2)
  }
  
  func testCreateALinkView() {
    // given
    let link = Link(origin: concept1, target: concept2)
    
    // when
    let linkView = LinkView(link: link, canvas: canvas)
    
    // then
    XCTAssertEqual(linkView.frame, link.rect)
  }
  
  func testLinkViewDrawingProportions() {
    // given
    canvas.drawConceptViews()
    let link = Link(origin: concept1, target: concept2)
    let linkView = LinkView(link: link, canvas: canvas)
    let concept1PointInLinkViewCoordinates = NSMakePoint(40, 30)
    let concept2PointInLinkViewCoordinates = NSMakePoint(200, 110)
    
    // when
    let arrow = linkView.constructArrow()
    
    // then
    let linkViewBoundsInCanvasCoordinates = canvas.convert(linkView.bounds, to: nil)
    XCTAssertEqual(linkView.bounds, NSMakeRect(0, 0, 200, 100))
    XCTAssertEqual(arrow!.p1, concept1PointInLinkViewCoordinates)
    XCTAssertEqual(arrow!.p2, concept2PointInLinkViewCoordinates)
    XCTAssert(linkViewBoundsInCanvasCoordinates.contains(arrow!.p1))
    XCTAssert(linkViewBoundsInCanvasCoordinates.contains(arrow!.p2))
  }
  
  func testSelectALinkByClickingOnIt() {
    // given
    let link1 = Link(origin: concept1, target: concept2)
    let link2 = Link(origin: concept2, target: concept1)
    testDocument.links = [link1, link2]
    canvas.drawConceptViews()
    canvas.drawLinkViews()
    let linkView = canvas.linkViewFor(link1)
    concept1.isSelected = true
    link2.isSelected = true
    
    // when
    linkView.click(NSMakePoint(20, 30))
    
    // then
    XCTAssertEqual(canvas.subviews.count, 4)
    XCTAssertEqual(link1.isSelected, true)
    XCTAssertEqual(concept1.isSelected, false)
    XCTAssertEqual(link2.isSelected, false)
  }
  
  func testDeletingALink() {
    // given
    let link = Link(origin: concept1, target: concept2)
    testDocument.links = [link]
    canvas.drawConceptViews()
    canvas.drawLinkViews()
    let linkView = canvas.linkViewFor(link)
    
    // when
    link.isSelected = true
    linkView.pressDeleteKey()
    
    // then
    XCTAssertEqual(canvas.links.count, 0)
    XCTAssertEqual(canvas.linkViews.count, 0)
    XCTAssertEqual(canvas.subviews.count, 2)
  }
}
