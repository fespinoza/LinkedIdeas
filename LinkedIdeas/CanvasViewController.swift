//
//  CanvasViewController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 29/08/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct DrawableConcept: DrawableElement {
  let concept: Concept
  
  func draw() {
    concept.attributedStringValue.draw(at: concept.point)
  }
}

extension NSResponder {
  var identifierString: String {
    return "\(type(of: self))"
  }
  
  func print(_ message: String) {
    Swift.print("\(identifierString): \(message)")
  }
}

class CanvasViewController: NSViewController {
  @IBOutlet weak var canvasView: CanvasView!
  
  var document: Document! {
    didSet {
      print("- didSetDocument \(document)")
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("-viewDidLoad")
    canvasView.dataSource = self
  }
  
  override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
    print("-prepareForSegue")
  }
}

extension CanvasViewController: CanvasViewDataSource {
  var drawableElements: [DrawableElement] {
    print("drawableElements")
    return document.concepts.map {
      DrawableConcept(concept: $0) as DrawableElement
    }
  }
}
