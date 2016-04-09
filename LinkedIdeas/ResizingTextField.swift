//
//  ResizingTextField.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 10/04/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class ResizingTextField: NSTextField {
  override func textDidChange(notification: NSNotification) {
    super.textDidChange(notification)
    invalidateIntrinsicContentSize()
    self.setFrameSize(intrinsicContentSize)
  }
  
  override var intrinsicContentSize: NSSize {
    let boundingSize: NSSize = stringValue.sizeWithAttributes(nil)
    
    let roundedWidth  = CGFloat(boundingSize.width + Concept.padding)
    let roundedHeight = CGFloat(boundingSize.height + Concept.padding)
    
    let result = NSSize(width: roundedWidth, height: roundedHeight)
    
    return result
  }
}