//
//  DocumentViewController.swift
//  LinkedIdeas-iOS
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit

public class DocumentViewController: UIViewController {
  // MARK: - public properties
  // MARK: - private properties
  // MARK: - UIViewController overrides
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white

    let label = UILabel()
    label.text = "Hello World!"
    label.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(label)

    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
    ])

  }

  // MARK: - public methods
  // MARK: - private methods
}