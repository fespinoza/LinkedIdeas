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
  }

  func applicationWillTerminate(_ aNotification: Notification) {
  }

  @IBAction func showTutorial(_ sender: Any?) {
    let viewController = TutorialViewController()
    let window = NSWindow(contentViewController: viewController)
    window.title = "Linked Ideas Tutorial"
    let windowController = NSWindowController(window: window)
    windowController.showWindow(self)
  }
}
