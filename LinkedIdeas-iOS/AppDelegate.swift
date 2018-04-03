//
//  AppDelegate.swift
//  LinkedIdeas-iOS
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)

    let documentBrowserVC = DocumentBrowserViewController()
    documentBrowserVC.view.frame = window.frame
    let mainNavigationController = UINavigationController(rootViewController: documentBrowserVC)
    mainNavigationController.isNavigationBarHidden = true

    window.rootViewController = mainNavigationController
    window.makeKeyAndVisible()

    self.window = window

    return true
  }

  func application(
    _ app: UIApplication, open inputURL: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    // Ensure the URL is a file URL
    guard inputURL.isFileURL else { return false }

    // Reveal / import the document at the URL
    guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else {
      return false
    }

    documentBrowserViewController.revealDocument(at: inputURL, importIfNeeded: true) { (revealedDocumentURL, error) in
      if let error = error {
        // Handle the error appropriately
        print("Failed to reveal the document at URL \(inputURL) with error: '\(error)'")
        return
      }

      // Present the Document View Controller for the revealed URL
      documentBrowserViewController.presentDocument(at: revealedDocumentURL!)
    }

    return true
  }
}
