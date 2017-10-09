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
      if let document = document as? Document {
        documentViewController?.document = document
        print("-didSetDocument")
      }
    }
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    print("-windowDidLoad")
  }

  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    print("-prepareForSegue")
  }

}
