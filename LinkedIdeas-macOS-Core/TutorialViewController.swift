//
//  TutorialViewController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza on 30/03/2018.
//  Copyright © 2018 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

public class TutorialViewController: NSViewController {
  public override func loadView() {
    self.view = NSView(frame: CGRect(x: 0, y: 0, width: 800, height: 570))
    self.view.wantsLayer = true
  }

  let pageController = NSPageController()
  let bundle = Bundle(for: TutorialViewController.self)

  public override func viewDidLoad() {
    super.viewDidLoad()

    let view = NSView()
    view.wantsLayer = true
    view.translatesAutoresizingMaskIntoConstraints = false

    pageController.view = view
    pageController.delegate = self
    pageController.transitionStyle = .horizontalStrip

    self.view.addSubview(view)

    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: self.view.topAnchor),
      view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70)
    ])


    let nextImageName = NSImage.Name.init("right")
    let nextImage = bundle.image(forResource: nextImageName)!
    let nextButton = NSButton(image: nextImage, target: self, action: #selector(next(_:)))
    nextButton.bezelStyle = .rounded
    nextButton.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(nextButton)

    NSLayoutConstraint.activate([
      nextButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      nextButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      nextButton.widthAnchor.constraint(equalToConstant: 40),
      nextButton.heightAnchor.constraint(equalToConstant: 40)
    ])

    let previousImageName = NSImage.Name("left")
    let previousImage = bundle.image(forResource: previousImageName)!
    let previousButton = NSButton(image: previousImage, target: self, action: #selector(previous(_:)))
    nextButton.bezelStyle = .rounded
    previousButton.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(previousButton)

    NSLayoutConstraint.activate([
      previousButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
      previousButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
      previousButton.widthAnchor.constraint(equalToConstant: 40),
      previousButton.heightAnchor.constraint(equalToConstant: 40)
    ])

    let closeButton = NSButton(title: "Close", target: self, action: #selector(close))
    closeButton.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(closeButton)

    NSLayoutConstraint.activate([
      closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
      closeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20)
    ])
  }

  public override func viewWillAppear() {
    super.viewWillAppear()

    self.pageController.arrangedObjects = Array(0...3)
  }

  @objc func next(_ sender: NSButton) {
    pageController.navigateForward(sender)
  }

  @objc func previous(_ sender: NSButton) {
    pageController.navigateBack(sender)
  }

  @objc func close(_ sender: NSButton) {
    self.view.window?.close()
  }
}

extension TutorialViewController: NSPageControllerDelegate {
  public func pageController(
    _ pageController: NSPageController, identifierFor object: Any
  ) -> NSPageController.ObjectIdentifier {
    // swiftlint:disable:next force_cast
    let string = String(object as! Int)

    return NSPageController.ObjectIdentifier.init("tutorial-\(string)")
  }

  public func pageController(
    _ pageController: NSPageController,
    viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier
  ) -> NSViewController {
    let view = NSView()
    view.wantsLayer = true
    view.frame = pageController.view.bounds

    let viewController = NSViewController()
    viewController.view = view

    let imageView = NSImageView()
    imageView.imageScaling = .scaleProportionallyUpOrDown

    let imageName = NSImage.Name(identifier.rawValue)
    imageView.image = bundle.image(forResource: imageName)

    view.addSubview(imageView)
    imageView.frame = view.bounds

    return viewController
  }
}
