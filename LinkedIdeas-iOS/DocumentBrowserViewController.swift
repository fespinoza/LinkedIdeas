//
//  DocumentBrowserViewController.swift
//  LinkedIdeas-iOS
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit
import LinkedIdeas_iOS_Core

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self

    allowsDocumentCreation = false
    allowsPickingMultipleItems = false
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
  }

  // MARK: UIDocumentBrowserViewControllerDelegate

  func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    didRequestDocumentCreationWithHandler importHandler:
      @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void
  ) {
    let newDocumentURL: URL? = nil

    // Set the URL for the new document here. Optionally, you can present a template chooser before calling the
    // importHandler.
    // Make sure the importHandler is always called, even if the user cancels the creation request.
    if newDocumentURL != nil {
      importHandler(newDocumentURL, .move)
    } else {
      importHandler(nil, .none)
    }
  }

  func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
    guard let sourceURL = documentURLs.first else { return }

    // Present the Document View Controller for the first document that was picked.
    // If you support picking multiple items, make sure you handle them all.
    presentDocument(at: sourceURL)
  }

  func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    didImportDocumentAt sourceURL: URL,
    toDestinationURL destinationURL: URL
  ) {
    // Present the Document View Controller for the new newly created document
    presentDocument(at: destinationURL)
  }

  func documentBrowser(
    _ controller: UIDocumentBrowserViewController,
    failedToImportDocumentAt documentURL: URL, error: Error?
  ) {
    // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
  }

  // MARK: Document Presentation

  func presentDocument(at documentURL: URL) {
    let documentViewController = DocumentViewController()
    documentViewController.document = Document(fileURL: documentURL)

    self.navigationController?.pushViewController(documentViewController, animated: true)
  }
}
