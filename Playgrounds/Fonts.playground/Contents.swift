//: Playground - noun: a place where people can play

import Cocoa

let stringValue = "Hello, playground"

var text = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 30))

text.stringValue = stringValue

let strikeThroughText = NSAttributedString(
  string: stringValue,
  attributes: [
    NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
  ]
)
text.attributedStringValue = strikeThroughText

let coloredText = NSAttributedString(
  string: stringValue,
  attributes: [
    NSForegroundColorAttributeName: NSColor.redColor()
  ]
)
text.attributedStringValue = coloredText
var range = NSMakeRange(0, coloredText.length)
var font = coloredText.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: &range) as? NSFont

if let font = font {
  let isBold = (font.fontDescriptor.symbolicTraits & UInt32(NSFontTraitMask.BoldFontMask.rawValue)) != 0
}

let boldFont = NSFontManager.sharedFontManager().convertFont(NSFont(name: "Helvetica", size: 18)!, toHaveTrait: .BoldFontMask)
let boldText = NSAttributedString(
  string: stringValue,
  attributes: [
    NSFontAttributeName: boldFont
  ]
)
text.attributedStringValue = boldText

range = NSMakeRange(0, boldText.length)
font = boldText.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: &range) as? NSFont

if let font = font {
  let isBold = (font.fontDescriptor.symbolicTraits & UInt32(NSFontTraitMask.BoldFontMask.rawValue)) != 0
}

//UIFont *font = [UIFont boldSystemFontOfSize:17.0f];
//UIFontDescriptor *fontDescriptor = font.fontDescriptor;
//UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
//BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
