import Cocoa
extension NSAttributedString {
  /// the NSRange for the full attributed string content
  var fullRange: NSRange {
    return NSRange(location: 0, length: string.count)
  }

  /// The font that is used in the full text
  var font: NSFont {
    let attributes = self.fontAttributes(in: fullRange)
    return (attributes[.font] as? NSFont) ?? NSFont(name: "Helvetica", size: 12.0)!
  }

  var fontSize: CGFloat {
    return font.pointSize
  }
}


let sampleAttributedString = NSMutableAttributedString(string: "Hello World")
let attributes = sampleAttributedString.fontAttributes(in: sampleAttributedString.fullRange)
sampleAttributedString.font

let newFont = NSFont(name: "Monaco", size: sampleAttributedString.fontSize)!
sampleAttributedString.addAttribute(NSAttributedStringKey.font, value: newFont, range: sampleAttributedString.fullRange)
sampleAttributedString.addAttribute(.font, value: newFont, range: sampleAttributedString.fullRange)
