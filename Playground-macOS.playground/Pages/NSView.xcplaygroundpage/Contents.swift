//: [Previous](@previous)

import Cocoa
import PlaygroundSupport

class MyViewController: NSViewController {
  override func loadView() {
    self.view = NSView(
      frame: CGRect(x: 0, y: 0, width: 300, height: 200)
    )
    self.view.wantsLayer = true
    self.view.layer?.backgroundColor = NSColor.blue.cgColor
  }
}

let viewController = MyViewController()

PlaygroundPage.current.liveView = viewController

//: [Next](@next)
