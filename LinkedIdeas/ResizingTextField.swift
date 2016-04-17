//
//  ResizingTextField.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 10/04/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class ResizingTextField: NSTextField {
  // TODO: decouple from ConcepView
  var conceptView: ConceptView?
  
  override func textDidChange(notification: NSNotification) {
    sprint("text did change")
    super.textDidChange(notification)
    invalidateIntrinsicContentSize()
    self.setFrameSize(intrinsicContentSize)
    conceptView?.updateFrameToMatchConcept()
  }
  
  override var intrinsicContentSize: NSSize {
//    let boundingSize: NSSize = stringValue.sizeWithAttributes(nil)
    let boundingSize: NSSize = attributedStringValue.size()
    
    let roundedWidth  = CGFloat(boundingSize.width + Concept.padding)
    let roundedHeight = CGFloat(boundingSize.height + Concept.padding)
    
    let result = NSSize(width: roundedWidth, height: roundedHeight)
    
    sprint("\(result)")
    return result
  }
}