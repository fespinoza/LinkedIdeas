//
//  CanvasView.swift
//  LinkedIdeas-iOS-Core
//
//  Created by Felipe Espinoza on 31/01/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import UIKit
import LinkedIdeas_Shared

public protocol CanvasViewDataSource {
  func drawableElements(forRect: CGRect) -> [DrawableConcept]
}

public class CanvasView: UIView {
  // MARK: - public properties
  public var dataSource: CanvasViewDataSource? {
    didSet {
      self.setNeedsDisplay()
    }
  }

  // MARK: - private properties

  // MARK: - Initializers
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: - UIView overrides
  public override func draw(_ rect: CGRect) {
    print(#function, rect)
    super.draw(rect)
    self.dataSource?.drawableElements(forRect: rect).forEach { $0.draw() }
  }

  // MARK: - private functions
  private func setup() {
    self.backgroundColor = .white
  }
}
