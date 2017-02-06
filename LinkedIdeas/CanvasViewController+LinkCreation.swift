//
//  CanvasViewController+LinkCreation.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 06/02/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

//## States + Transitions
//
//- **selectedElement** -> "shift+drag" -> "drag release" -> **creating Link** -> "press enter" -> **link saved** -> **selected Element (link)**
//
//- **selected element** + "press ENTER" event => **editing element**
//- **selected element** + "press DELETE" event => **canvas waiting** + deletion of element
//
//- **link saved**:
//- concept A is not selected
//- concept B is not selected
//- link A+B is selected

// MARK: CanvasViewController+LinkCreation
extension CanvasViewController {
  func creationArrowForLink(toPoint: NSPoint) {
    
  }
  
  func createTemporaryLink(fromConcept: Concept, toConcept: Concept) {
  }
  
  func cancelLinkCreation() {
    
  }
}
