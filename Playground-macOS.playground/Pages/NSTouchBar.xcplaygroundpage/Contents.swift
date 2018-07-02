import AppKit
import Foundation
import PlaygroundSupport


let stackViewIdentifier = NSTouchBarItem.Identifier("com.fespinozacast.linkedideas.touchbar.stackview")
let colorGroupIdentifier = NSTouchBarItem.Identifier("com.fespinozacast.linkedideas.touchbar.colorgroup")
let scrubberIdentifier = NSTouchBarItem.Identifier("com.fespinozacast.linkedideas.touchbar.colorgroup2")

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
  button.wantsLayer = true
  button.bezelColor = color
  button.layer?.borderWidth = 1
  button.layer?.borderColor = color.blended(withFraction: 0.5, of: NSColor.white)?.cgColor
  button.layer?.cornerRadius = 5
  return button
}

let colorItems = DefaultColors.allColors.enumerated().map { pair -> NSCustomTouchBarItem in
  let identifier = NSTouchBarItem.Identifier("com.fespinozacast.linkedideas.touchbar.colorgroup.color-\(pair.offset)")
  let item = NSCustomTouchBarItem(identifier: identifier)
  let button = coloredButton(pair.element)
  item.view = button
  button.widthAnchor.constraint(equalToConstant: 50).isActive = true
  return item
}

let coloredButtons = DefaultColors.allColors.map { color -> NSButton in
  let button = coloredButton(color)
  button.widthAnchor.constraint(equalToConstant: 50).isActive = true
  return button
}
let stackView = NSStackView(views: coloredButtons)
stackView.spacing = 0

let stackViewItem = NSCustomTouchBarItem(identifier: stackViewIdentifier)
stackViewItem.view = stackView

let bar = NSTouchBar()
bar.defaultItemIdentifiers = [colorGroupIdentifier, stackViewIdentifier, scrubberIdentifier]

let group = NSGroupTouchBarItem(identifier: colorGroupIdentifier, items: colorItems)

bar.templateItems = [group]
bar.templateItems = [stackViewItem]

class ScrubberHelper: NSObject, NSScrubberDelegate, NSScrubberDataSource {
  public func numberOfItems(for scrubber: NSScrubber) -> Int {
    return DefaultColors.allColors.count
  }

  public func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
    let color = DefaultColors.allColors[index]
    let view = NSScrubberItemView()
    view.wantsLayer = true
    view.layer?.backgroundColor = color.cgColor
    view.layer?.borderWidth = 1
    view.layer?.borderColor = NSColor.gray.cgColor
    view.layer?.cornerRadius = 5
    return view
  }
}
let helper = ScrubberHelper()
let scrubber = NSScrubber()
let layout = NSScrubberFlowLayout()

//scrubber.wantsLayer = true
//scrubber.layer?.borderWidth = 1
//scrubber.layer?.borderColor = NSColor.gray.cgColor
scrubber.dataSource = helper
scrubber.delegate = helper
scrubber.scrubberLayout = layout

let scrubberItem = NSCustomTouchBarItem(identifier: scrubberIdentifier)
scrubberItem.view = scrubber

bar.templateItems = [scrubberItem]













