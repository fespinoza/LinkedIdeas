//
//  Settings.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 02/10/2019.
//  Copyright © 2019 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

struct Settings {
  @UserDefault("LinkedIdeas_SavedAppearanceKey", defaultValue: nil)
  static var savedAppearanceName: String?

  let appearance: NSAppearance?

  static var savedAppearanceIndex: Int {
    switch savedAppearanceName {
    case NSAppearance.Name.aqua.rawValue: return 1
    case NSAppearance.Name.darkAqua.rawValue: return 2
    default: return 0
    }
  }

  static func appearance(for index: Int) -> NSAppearance? {
    switch index {
    case 1: return NSAppearance(named: .aqua)
    case 2: return NSAppearance(named: .darkAqua)
    default: return nil
    }
  }

  static func setAppAppearance(_ appearance: NSAppearance?) {
    savedAppearanceName = appearance?.name.rawValue
    NSApp.appearance = appearance
  }

  static func loadSavedAppearance() {
    if let savedAppearanceName = Settings.savedAppearanceName,
      let appearance = NSAppearance(named: NSAppearance.Name(savedAppearanceName)) {
        NSApp.appearance = appearance
    } else {
        NSApp.appearance = nil
    }
  }
}
