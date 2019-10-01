//
//  CanvasViewController+NSTouchBar.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 24/06/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import AppKit
import LinkedIdeas_Shared

extension CanvasViewController {
  @available(OSX 10.12.2, *)
  override func makeTouchBar() -> NSTouchBar? {
    let colorGroupIdentifier = NSTouchBarItem.Identifier("com.fespinozacast.linkedideas.touchbar.colorgroup")

    let colorItems = DefaultColors.allColors.enumerated().map { pair -> NSCustomTouchBarItem in
      let identifier = NSTouchBarItem.Identifier(
        "com.fespinozacast.linkedideas.touchbar.colorgroup.color-\(pair.offset)"
      )
      let item = NSCustomTouchBarItem(identifier: identifier)
      let button = buttonFactory(withColor: pair.element)
      button.tag = pair.offset
      item.view = button
      button.widthAnchor.constraint(equalToConstant: 50).isActive = true
      return item
    }

    let bar = NSTouchBar()
    bar.defaultItemIdentifiers = [colorGroupIdentifier]

    let group = NSGroupTouchBarItem(identifier: colorGroupIdentifier, items: colorItems)

    bar.templateItems = [group]

    return bar
  }

  @available(OSX 10.12.2, *)
  private func buttonFactory(withColor color: NSColor) -> NSButton {
    let button = NSButton(title: " ", target: self, action: #selector(changeColorWithTouchbar(_:)))
    button.wantsLayer = true
    button.bezelColor = color
    button.layer?.borderWidth = 1
    button.layer?.borderColor = color.blended(withFraction: 0.5, of: NSColor.white)?.cgColor
    button.layer?.cornerRadius = 5
    return button
  }

  @objc private func changeColorWithTouchbar(_ sender: NSButton) {
    let color = DefaultColors.allColors[sender.tag]
    setColorForSelectedElements(fontColor: color)
  }
}
