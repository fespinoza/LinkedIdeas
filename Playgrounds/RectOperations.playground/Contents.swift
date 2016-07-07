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

let canvas = SimpleView(frame: NSMakeRect(0, 0, 600, 400), color: NSColor.whiteColor(), index: nil)

// show some rectangles in the screen
let rects = [
  NSMakeRect(40, 40, 100, 40),
  NSMakeRect(240, 80, 100, 60),
  NSMakeRect(400, 20, 120, 40),
  NSMakeRect(80, 200, 100, 40),
  NSMakeRect(220, 220, 140, 60),
  NSMakeRect(400, 250, 100, 40),
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