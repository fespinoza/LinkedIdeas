//: [Previous](@previous)

import UIKit
import LinkedIdeas_iOS_Core
import LinkedIdeas_Shared
import PlaygroundSupport

guard let url = Bundle.main.url(forResource: "sample-doc", withExtension: "idea"),
  let data = try? Data(contentsOf: url) else {
    preconditionFailure("i should be able to read the doc")
}

let document = Document(fileURL: url)
try? document.load(fromContents: data, ofType: "idea")

let concepts = document.concepts

let union = concepts.map({ $0.area }).reduce(nil) { (result, newRect) -> CGRect? in
  if let result = result {
    return result.union(newRect)
  } else {
    return newRect
  }
}!

//let union = concepts.map({ $0.area }).reduce(CGRect.zero) { (result, newRect) -> CGRect in
//  return result.union(newRect)
//}

print(concepts.map { $0.area })
print(union)

//: [Next](@next)
