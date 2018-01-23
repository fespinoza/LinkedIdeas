//
//  Document.swift
//  LinkedIdeas-iOS
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit
import LinkedIdeas_Shared

class Document: UIDocument {

  override func contents(forType typeName: String) throws -> Any {
    // Encode your document with an instance of NSData or NSFileWrapper
    return Data()
  }

  override func load(fromContents contents: Any, ofType typeName: String?) throws {
    NSKeyedUnarchiver.setClass(DocumentData.self, forClassName: "LinkedIdeas.DocumentData")
    NSKeyedUnarchiver.setClass(Concept.self, forClassName: "LinkedIdeas.Concept")
    NSKeyedUnarchiver.setClass(Link.self, forClassName: "LinkedIdeas.Link")

    if let data = contents as? Data {
      guard let documentData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DocumentData else {
        return
      }

      documentData.readConcepts?.forEach({ Swift.print($0.description) })
    }
  }
}

