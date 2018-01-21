//
//  DocumentData.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

public class DocumentData: NSObject, NSCoding {
  var readConcepts: [Concept]?
  var readLinks: [Link]?
  var writeConcepts: [Concept]?
  var writeLinks: [Link]?

  override public init() {
    super.init()
  }

  required public init?(coder aDecoder: NSCoder) {
    guard let readConcepts = aDecoder.decodeObject(forKey: "concepts") as? [Concept]?,
          let readLinks = aDecoder.decodeObject(forKey: "links") as? [Link]?
      else {
        return nil
    }

    // This code fixes the flip of the coordinate system
//    self.readConcepts = readConcepts!.map({ (concept) -> Concept in
//      let oldPoint = concept.point
//      concept.point = CGPoint(x: oldPoint.x, y: 2000 - oldPoint.y)
//      return concept
//    })
    self.readConcepts = readConcepts
    self.readLinks = readLinks
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(writeConcepts, forKey: "concepts")
    aCoder.encode(writeLinks, forKey: "links")
  }
}

class Graph: NSObject, NSCoding {
  var concepts = [Concept]()
  var links = [Link]()

  required init?(coder aDecoder: NSCoder) {

    guard let concepts = aDecoder.decodeObject(forKey: "concepts") as? [Concept],
          let links = aDecoder.decodeObject(forKey: "links") as? [Link]
      else {
        return nil
    }

    self.concepts = concepts
    self.links = links
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(concepts, forKey: "concepts")
    aCoder.encode(links, forKey: "links")
  }

}
