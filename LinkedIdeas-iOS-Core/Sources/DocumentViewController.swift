//
//  DocumentViewController.swift
//  LinkedIdeas-iOS
//
//  Created by Felipe Espinoza on 20/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit
import LinkedIdeas_Shared

public class DocumentViewController: UIViewController {
  public var document: Document! {
    didSet {
      print(#function)
      canvasView.setNeedsDisplay()
    }
  }

  // MARK: - private properties
  private let canvasFrame = CGRect(x: 0, y: 0, width: 3000, height: 2000)
  private lazy var canvasView: CanvasView = {
    let canvasView = CanvasView(frame: self.canvasFrame)
    canvasView.dataSource = self

    return canvasView
  }()

  // MARK: - UIViewController overrides
  public override func viewDidLoad() {
    self.view.backgroundColor = .purple

    self.view.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)

    let scrollView = UIScrollView()
    scrollView.contentSize = self.canvasFrame.size
    scrollView.translatesAutoresizingMaskIntoConstraints = false

    // subviews
    scrollView.addSubview(canvasView)
    self.view.addSubview(scrollView)

    // autolayout
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
    ])

    document.open { [weak self] (success) in
      print("open \(success)")
      if let strongSelf = self, let viewBounds = self?.view.bounds {
        self?.canvasView.setNeedsDisplay(viewBounds)

        let rect = strongSelf.document.documentFocusRect()
        scrollView.setContentOffset(rect.origin, animated: false)
      }
    }
  }
}

extension DocumentViewController: CanvasViewDataSource {
  public func drawableElements(forRect rect: CGRect) -> [DrawableConcept] {
    return document.concepts
      .filter({ $0.area.intersects(rect) })
      .flatMap({ DrawableConcept(concept: $0) })
  }
}
