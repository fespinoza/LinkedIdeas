//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport

/*

 # NSTextView + Resetting Attributes experiments

 the idea is to check how to reset the NSTextView's attributes i added

 A good indication is `NSTextView.typingAttributes`

 */


class BasicDelegate: NSObject, NSTextViewDelegate {
  func textDidChange(_ notification: Notification) {
    guard let textView = notification.object as? NSTextView else {
      return
    }

    print(textView.attributedString())
  }

  func textViewDidChangeSelection(_ notification: Notification) {
    guard let textView = notification.object as? NSTextView else {
      return
    }

    print("------")

    print(textView.textStorage!)

//    print(textView.attributedString())
  }

  func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
    switch commandSelector {
    case #selector(NSTextView.insertNewline(_:)):
      print("do something!")

      guard let textStorage = textView.textStorage else {
        print("no text storage")
        return true
      }

      let defaultAttributes: [NSAttributedStringKey: Any] = [
        .foregroundColor: NSColor.black,
        .font: NSFont.systemFont(ofSize: 12)
      ]
      let fullRange = NSRange(location: 0, length: textStorage.length)
      textView.textStorage?.setAttributes(defaultAttributes, range: fullRange)

    default:
      print("unhandled \(commandSelector)")
    }

    return true
  }
}

var str = "Hello, playground"

let delegate = BasicDelegate()

let textView = NSTextView(frame: NSRect(x: 0, y: 0, width: 300, height: 150))
textView.string = str
textView.delegate = delegate

PlaygroundPage.current.liveView = textView
