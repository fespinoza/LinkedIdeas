//
//  AppDelegate.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 02/11/15.
//  Copyright © 2015 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import HockeySDK

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
    if let sharedHockeyManager = BITHockeyManager.shared() {
      sharedHockeyManager.configure(withIdentifier: "910181e274534fc1a9c01ad131c17ea8")
      sharedHockeyManager.start()
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

}
