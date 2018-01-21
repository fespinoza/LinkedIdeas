//
//  Document.swift
//  LinkedIdeas-iOS
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit

//class DocumentData: NSObject, NSCoding {
//  let concepts: [Concept]
//
//  required init?(coder aDecoder: NSCoder) {
//    guard let concepts = aDecoder.decodeObject(forKey: "concepts") as? [Concept] else {
//      return nil
//    }
//
//    self.concepts = concepts
//  }
//
//  func encode(with aCoder: NSCoder) {
//  }
//}

class Document: UIDocument {

  override func contents(forType typeName: String) throws -> Any {
    // Encode your document with an instance of NSData or NSFileWrapper
    return Data()
  }

  override func load(fromContents contents: Any, ofType typeName: String?) throws {
//    Swift.print("Document: -read")
//    guard let documentData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DocumentData else {
//      return
//    }
//    self.documentData = documentData
//    if let readConcepts = documentData.readConcepts {
//      concepts = readConcepts
//    }
//    if let readLinks = documentData.readLinks {
//      links = readLinks
//    }

//    guard let readConcepts = aDecoder.decodeObject(forKey: "concepts") as? [Concept]?,

    if let data = contents as? Data {
      guard let documentData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DocumentData else {
        return
      }

      documentData.concepts.forEach({ Swift.print($0.description) })
    }
  }
}

