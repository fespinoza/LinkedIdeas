//
//  NSView.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 30/03/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension NSView {
  func pin(to view: NSView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      self.topAnchor.constraint(equalTo: view.topAnchor),
      self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
