//
//  DocumentViewController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 27/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class DocumentViewController: NSViewController, Identifiable {
  var uuid: String
  
  var canvasViewController: CanvasViewController! {
    return childViewControllers.lazy.first as? CanvasViewController
  }
  
  var document: Document! {
    didSet {
      canvasViewController.document = document
      print("-didSetDocument")
    }
  }
  
  // MARK: - Initialization
  
  required init?(coder: NSCoder) {
    uuid = UUID().uuidString
    super.init(coder: coder)
    print("init")
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
