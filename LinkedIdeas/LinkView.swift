//
//  LinkView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 28/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class LinkView: NSView {
  let link: Link
  let editing: Bool
  var textField: NSTextField?
  
  init(frame frameRect: NSRect, link: Link) {
    self.link = link
    self.editing = true
    super.init(frame: frameRect)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(dirtyRect: NSRect) {
    super.drawRect(dirtyRect)
    drawArrow()
    drawBorderForRect(bounds)
    drawCenteredDotAtPoint(bounds.center)
    // if editing { drawTextField() }
  }
  
  // MARK: - Drawing methods
  
  func drawArrow() {
    NSColor.redColor().set()
    let path = NSBezierPath()
    
    let origin = convertPoint(link.originPoint, fromView: nil)
    let target = convertPoint(link.targetPoint, fromView: nil)
    sprint(origin.description())
    sprint(target.description())
    path.moveToPoint(origin)
    path.lineToPoint(target)
    drawCenteredDotAtPoint(origin, color: NSColor.redColor())
    drawCenteredDotAtPoint(target, color: NSColor.cyanColor())
    
    // check how draw arrow defines coordinates
    
    // LinkedIdeas.LinkView: (0.0, 0.0) [174.90625, 139.21875]
    // LinkedIdeas.LinkView: (-20.0, 119.21875)
    // LinkedIdeas.LinkView: (154.90625, -20.0)
    
    path.stroke()
  }
  
  func drawTextField() {
    if (textField == nil) { initTextField() }
    toggleTextField()
  }
  
  func drawLinkText() {
    if !editing {
      if let string = link.stringValue {
        let attrs = [
          NSForegroundColorAttributeName: NSColor.blackColor()
        ]
        string.drawInRect(textFieldRect(), withAttributes: attrs)
      }
    }
  }
  
  // MARK: - View Logic Methods
  
  func middlePoint() -> NSPoint {
    let x = (link.originPoint.x + link.targetPoint.x) / 2.0
    let y = (link.originPoint.y + link.targetPoint.y) / 2.0
    let point = NSPoint(x: x, y: y)
    return convertPoint(point, fromView: nil)
  }
  
  // MARK: - TextFieldLogic
  
  func initTextField() {
    let textField = NSTextField(frame: textFieldRect())
    textField.placeholderString = "name"
    textField.enabled = true
    textField.editable = true
    self.textField = textField
    addSubview(textField)
    textField.becomeFirstResponder()
  }
  
  func textFieldRect() -> NSRect {
    let size = NSSize(width: 20.0, height: 10.0)
    var middlePointFixed = self.middlePoint()
    middlePointFixed.x -= size.width / 2.0
    middlePointFixed.y -= size.height / 2.0
    return NSRect(origin: middlePointFixed, size: size)
  }
  
  // MARK: - TextField events
  
  func toggleTextField() {
    if editing {
      enableTextField()
    } else {
      disableTextField()
    }
  }
  
  func enableTextField() {
    if let textField = textField {
      textField.hidden = false
      textField.editable = true
    }
  }
  
  func disableTextField() {
    if let textField = textField {
      textField.hidden = true
      textField.editable = false
    }
  }
  
  // MARK: - others
  
  func desc() -> String {
    return "\(bounds.origin.description()) [\(bounds.size.width), \(bounds.size.height)]"
  }
}

extension NSView {
  func drawBounds() {
    NSColor.blueColor().set()
    let path = NSBezierPath()
    let p1 = bounds.origin
    let p2 = NSPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y)
    let p3 = NSPoint(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height)
    let p4 = NSPoint(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height)
    path.moveToPoint(p1)
    path.lineToPoint(p2)
    path.lineToPoint(p3)
    path.lineToPoint(p4)
    path.lineToPoint(p1)
    path.stroke()
  }
}

extension NSPoint {
  func description() -> String {
    return "(\(x), \(y))"
  }
}