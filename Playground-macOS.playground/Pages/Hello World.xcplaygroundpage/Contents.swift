import Cocoa

NSImage.init(contentsOfFile: "tutorial-00.jpg")

//NSImage.init(byReferencingFile: "tutorial-00")


// images on macos
let fileURL = Bundle.main.url(forResource: "tutorial-00", withExtension: "jpg")
let image = NSImage.init(contentsOf: fileURL!)

let imageView = NSImageView(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
imageView.image = image
imageView.frame

import PlaygroundSupport

PlaygroundPage.current.liveView = imageView
