//: Playground - noun: a place where people can play

import UIKit
import LinkedIdeas_iOS_Core
import PlaygroundSupport

print("starting...")

// reading a text file
if let url = Bundle.main.url(forResource: "sample-doc", withExtension: "md") {
  print(url)
  let string = try? String(contentsOf: url, encoding: .utf8)
  print(string)
}

// reading a test document
if let url = Bundle.main.url(forResource: "sample-doc", withExtension: "idea") {
  if let data = try? Data(contentsOf: url) {
    print("it worked!!!!")

    let document = Document(fileURL: url)
    do {
      try document.load(fromContents: data, ofType: "idea")
    } catch {
      print("❌ coudln't open the file because of \(error)")
    }
  }
}
