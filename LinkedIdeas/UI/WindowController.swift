//
//  WindowController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 28/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  var documentViewController: DocumentViewController? {
    return contentViewController as? DocumentViewController
  }

  override var document: AnyObject? {
    didSet {
      guard let document = document as? Document else {
        return
      }
      documentViewController?.document = document
    }
  }
}
