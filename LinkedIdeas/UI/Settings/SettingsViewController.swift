//
//  SettingsViewController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 01/10/2019.
//  Copyright © 2019 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
  @IBOutlet weak var interfaceStyleSelector: NSPopUpButton!

  @IBAction func setNewInterterfaceStyle(_ sender: NSPopUpButton) {
    switch sender.indexOfSelectedItem {
    case 0:
      NSApp.appearance = nil
    case 1:
      NSApp.appearance = NSAppearance(named: .aqua)
    case 2:
      NSApp.appearance = NSAppearance(named: .darkAqua)
    default:
      break
    }
  }
}
