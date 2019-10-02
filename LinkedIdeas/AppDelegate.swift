//
//  AppDelegate.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_macOS_Core

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if shouldOpenTutorial() {
      showHelp(self)
    }

    Settings.loadSavedAppearance()
  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }

  @IBAction func showHelp(_ sender: Any?) {
    let viewController = TutorialViewController()
    let window = NSWindow(contentViewController: viewController)
    window.styleMask = [.closable, .titled]
    window.title = "Linked Ideas Tutorial"
    let windowController = NSWindowController(window: window)
    windowController.showWindow(self)
  }

  private func shouldOpenTutorial() -> Bool {
    return UserDefaults.standard.value(forKey: "openTutorial") == nil ||
      UserDefaults.standard.bool(forKey: "openTutorial")
  }
}
