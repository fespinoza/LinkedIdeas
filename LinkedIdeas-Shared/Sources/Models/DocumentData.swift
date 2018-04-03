//
//  DocumentData.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

private extension String {
  static let conceptsKey = "concepts"
  static let linksKey = "links"
}

public class DocumentData: NSObject, NSCoding {
  public let concepts: [Concept]
  public let links: [Link]

  override public init() {
    self.concepts = []
    self.links = []
    super.init()
  }

  public init(concepts: [Concept], links: [Link]) {
    self.concepts = concepts
    self.links = links
    super.init()
  }

  required public init?(coder aDecoder: NSCoder) {
    guard let concepts = aDecoder.decodeObject(forKey: .conceptsKey) as? [Concept],
          let links = aDecoder.decodeObject(forKey: .linksKey) as? [Link] else {
        return nil
    }

    self.concepts = concepts
    self.links = links
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(self.concepts, forKey: .conceptsKey)
    aCoder.encode(self.links, forKey: .linksKey)
  }
}

//class Graph: NSObject, NSCoding {
//  var concepts = [Concept]()
//  var links = [Link]()
//
//  required init?(coder aDecoder: NSCoder) {
//
//    guard let concepts = aDecoder.decodeObject(forKey: "concepts") as? [Concept],
//          let links = aDecoder.decodeObject(forKey: "links") as? [Link]
//      else {
//        return nil
//    }
//
//    self.concepts = concepts
//    self.links = links
//  }
//
//  func encode(with aCoder: NSCoder) {
//    aCoder.encode(concepts, forKey: "concepts")
//    aCoder.encode(links, forKey: "links")
//  }
//
//}
