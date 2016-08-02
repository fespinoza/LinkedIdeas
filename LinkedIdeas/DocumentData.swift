//
//  DocumentData.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/05/2016.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Foundation

class DocumentData: NSObject, NSCoding {
  var readConcepts: [Concept]?
  var readLinks: [Link]?
  var writeConcepts: [Concept]?
  var writeLinks: [Link]?
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    readConcepts = aDecoder.decodeObject(forKey: "concepts") as! [Concept]?
    readLinks = aDecoder.decodeObject(forKey: "links") as! [Link]?
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(writeConcepts, forKey: "concepts")
    aCoder.encode(writeLinks, forKey: "links")
  }
}
