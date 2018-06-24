import AppKit
import Foundation
import PlaygroundSupport

let colorGroupIdentifier = NSTouchBarItem.Identifier("com.fespinozacast.linkedideas.touchbar.colorgroup")

struct DefaultColors {
  static let color1 = NSColor.black
  static let color2 = NSColor(red: 0/255,   green: 75/255,  blue: 213/255, alpha: 1.0)
  static let color3 = NSColor(red: 226/255, green: 6/255,   blue: 6/255,   alpha: 1.0)
  static let color4 = NSColor(red: 83/255,  green: 153/255, blue: 6/255,   alpha: 1.0)
  static let color5 = NSColor(red: 162/255, green: 8/255,   blue: 174/255, alpha: 1.0)
  static let color6 = NSColor(red: 255/255, green: 95/255,  blue: 0/255,   alpha: 1.0)
  static let color7 = NSColor(red: 73/255,  green: 9/255,   blue: 152/255, alpha: 1.0)

  static let allColors = [color1, color2, color3, color4, color5, color6, color7]
}

var coloredButton: (NSColor) -> NSButton = { color in
  let button = NSButton(title: " ", target: nil, action: nil)
  button.bezelColor = color
  return button
}

let colorItems = DefaultColors.allColors.enumerated().map { pair -> NSCustomTouchBarItem in
  let identifier = NSTouchBarItem.Identifier("com.fespinozacast.linkedideas.touchbar.colorgroup.color-\(pair.offset)")
  let item = NSCustomTouchBarItem(identifier: identifier)
  item.view = coloredButton(pair.element)
  return item
}

let bar = NSTouchBar()
bar.defaultItemIdentifiers = [colorGroupIdentifier]

let group = NSGroupTouchBarItem(identifier: colorGroupIdentifier, items: colorItems)

bar.templateItems = [group]

PlaygroundPage.current.liveTouchBar = bar
