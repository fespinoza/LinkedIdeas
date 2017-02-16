//: Playground - noun: a place where people can play

import Cocoa

class SimpleView: NSView {
  let color: NSColor
  var index: Int?

  init(frame frameRect: NSRect, color: NSColor, index: Int?) {
    self.color = color
    super.init(frame: frameRect)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func drawRect(dirtyRect: NSRect) {
    color.set()
    NSRectFill(bounds)
    if let index = index {
      NSColor.blackColor().set()
      let string = "R\(index)"
      string.drawInRect(bounds, withAttributes: nil)
    }
  }
}

let canvas = SimpleView(frame: NSRect(x: 0, y: 0, width: 600, height: 400), color: NSColor.whiteColor(), index: nil)

// show some rectangles in the screen
let rects = [
  NSRect(x: 40, y: 40, width: 100, height: 40),
  NSRect(x: 240, y: 80, width: 100, height: 60),
  NSRect(x: 400, y: 20, width: 120, height: 40),
  NSRect(x: 80, y: 200, width: 100, height: 40),
  NSRect(x: 220, y: 220, width: 140, height: 60),
  NSRect(x: 400, y: 250, width: 100, height: 40),
]
let colors = [
  NSColor.redColor(),
  NSColor.greenColor(),
  NSColor.blueColor(),
  NSColor.purpleColor(),
  NSColor.orangeColor(),
  NSColor.brownColor()
]
for (index, rect) in rects.enumerate() {
  let view = SimpleView(frame: rect, color: colors[index], index: index)
  canvas.addSubview(view)
}
canvas

// determine which rectangles are in a row?
// determine which rectangles are in a column?
// how many rows there are
// how many colums there are
// what is the height of the each row
// what is the width of each column
// what is the new size of RX in the "table"
