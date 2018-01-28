//
//  Document.swift
//  LinkedIdeas-iOS
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit
import LinkedIdeas_Shared

private extension String {
  static let documentDataClassName = "LinkedIdeas.DocumentData"
  static let conceptClassName = "LinkedIdeas.Concept"
  static let linkClassName = "LinkedIdeas.Link"
}

public class Document: UIDocument {
  private var documentData: DocumentData!

  public var concepts: [Concept] {
    return self.documentData.concepts
  }

  public var links: [Link] {
    return self.documentData.links
  }

  override public func contents(forType typeName: String) throws -> Any {
    // Encode your document with an instance of NSData or NSFileWrapper
    return Data()
  }

  override public func load(fromContents contents: Any, ofType typeName: String?) throws {
    NSKeyedUnarchiver.setClass(DocumentData.self, forClassName: .documentDataClassName)
    NSKeyedUnarchiver.setClass(Concept.self, forClassName: .conceptClassName)
    NSKeyedUnarchiver.setClass(Link.self, forClassName: .linkClassName)

    if let data = contents as? Data {
      guard let documentData = NSKeyedUnarchiver.unarchiveObject(with: data) as? DocumentData else {
        return
      }

      self.documentData = documentData
    } else {
      print("no data :(", contents, typeName ?? "none")
    }
  }
}

