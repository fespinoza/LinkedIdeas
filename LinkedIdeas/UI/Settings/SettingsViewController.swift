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

  override func viewDidLoad() {
    super.viewDidLoad()

    interfaceStyleSelector.selectItem(at: Settings.savedAppearanceIndex)
  }

  @IBAction func setNewInterterfaceStyle(_ sender: NSPopUpButton) {
    let appearance = Settings.appearance(for: sender.indexOfSelectedItem)
    Settings.setAppAppearance(appearance)
  }
}
