
//  DocumentViewController.swift
//  LinkedIdeas-iOS
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit
import LinkedIdeas_Shared

public class DocumentViewController: UIViewController {
  public var document: Document!

  // MARK: - private properties
  private let canvasFrame = CGRect(x: 0, y: 0, width: 3000, height: 2000)
  private lazy var canvasView: CanvasView = {
    let canvasView = CanvasView(frame: self.canvasFrame)
    canvasView.dataSource = self

    return canvasView
  }()

  // MARK: - UIViewController overrides
  public override func viewDidLoad() {
    self.view.backgroundColor = .white

    let scrollView = UIScrollView()
    scrollView.contentSize = self.canvasFrame.size
    scrollView.translatesAutoresizingMaskIntoConstraints = false

    // subviews
    scrollView.addSubview(canvasView)
    self.view.addSubview(scrollView)

    // autolayout
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
    ])

    document.open { [weak self] (success) in
      print("open \(success)")
      if let strongSelf = self {
        strongSelf.canvasView.setNeedsDisplay()

        let rect = strongSelf.document.documentFocusRect()
        scrollView.setContentOffset(rect.origin, animated: false)

        strongSelf.navigationItem.title = strongSelf.document.localizedName
      }
    }
  }

  public override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
    self.navigationItem.largeTitleDisplayMode = .always
    self.canvasView.setNeedsDisplay()
  }
}

extension DocumentViewController: CanvasViewDataSource {
  public func drawableElements(forRect rect: CGRect) -> [DrawableConcept] {
    return document.concepts
      .filter({ $0.area.intersects(rect) })
      .flatMap({ DrawableConcept(concept: $0) })
  }
}
