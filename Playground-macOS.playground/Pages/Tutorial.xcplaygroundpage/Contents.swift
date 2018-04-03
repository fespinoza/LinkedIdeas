import Cocoa
import PlaygroundSupport
import LinkedIdeas_macOS_Core

// usage
let controller = TutorialViewController()
controller.view.wantsLayer = true
controller.view.layer?.backgroundColor = NSColor.lightGray.cgColor

PlaygroundPage.current.liveView = controller
