//
//  DocumentViewController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 27/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class DocumentViewController: NSViewController {
  var canvasViewController: CanvasViewController! {
    return childViewControllers.lazy.first as? CanvasViewController
  }

  var document: Document! {
    didSet {
      canvasViewController.document = document
      print("-didSetDocument")
    }
  }

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    print("-viewDidLoad")
  }

  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    print("-prepareForSegue")
  }

}
