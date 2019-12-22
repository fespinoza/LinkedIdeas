//
//  CanvasViewController+MenuActions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 11/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

extension NSColor {
  convenience init(fullRed: CGFloat, fullGreen: CGFloat, fullBlue: CGFloat) {
    func normalizeValue(colorValue: CGFloat) -> CGFloat {
      return colorValue / 255
    }

    self.init(
      red: normalizeValue(colorValue: fullRed),
      green: normalizeValue(colorValue: fullGreen),
      blue: normalizeValue(colorValue: fullBlue),
      alpha: 1.0
    )
  }
}

extension CanvasViewController: NSColorChanging {
  func changeColor(_ sender: NSColorPanel?) {
    guard let colorPanel = sender else {
      return
    }

    setColorForSelectedElements(fontColor: colorPanel.color)
  }
}

extension CanvasViewController {

  override func selectAll(_ sender: Any?) {
    safeTransiton {
      try stateManager.toMultipleSelectedElements(elements: document.concepts)
    }
  }

  @objc func changeFont(_ sender: Any?) {
    guard let menuItem = sender as? NSMenuItem else {
      return
    }

    switch menuItem.title {
    case "Bold":
      makeSelectedElementsBold()
    case "Strikethrough":
      strikethroughSelectedElements()
    case "Bigger":
      makeSelectedElementsBigger()
    case "Smaller":
      makeSelectedElementsSmaller()
    default:
      break
    }
  }

  @IBAction func menuChangeColor(_ sender: Any?) {
    if let colorPanel = sender as? NSColorPanel {
      setColorForSelectedElements(fontColor: colorPanel.color)
    } else if let menuItem = sender as? NSMenuItem {
      switch menuItem.title {
      case "Color #1":
        setColorForSelectedElements(fontColor: DefaultColors.color1)
      case "Color #2":
        setColorForSelectedElements(fontColor: DefaultColors.color2)
      case "Color #3":
        setColorForSelectedElements(fontColor: DefaultColors.color3)
      case "Color #4":
        setColorForSelectedElements(fontColor: DefaultColors.color4)
      case "Color #5":
        setColorForSelectedElements(fontColor: DefaultColors.color5)
      case "Color #6":
        setColorForSelectedElements(fontColor: DefaultColors.color6)
      case "Color #7":
        setColorForSelectedElements(fontColor: DefaultColors.color7)
      default:
        break
      }
    }
  }

  @objc func zoomImageToActualSize(_ sender: Any?) {
    self.scrollView.setMagnification(1.0, centeredAt: self.scrollView.visibleRect.center)
  }

  @IBAction func toCodeFont(_ sender: Any?) {
    for concept in currentSelectedConcepts() {
      concept.attributedStringValue = NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontName: .codeFontName
      )
    }
  }

  // MARK: - custom methods

  func currentSelectedConcepts() -> [Concept] {
    switch currentState {
    case .selectedElement(let element):
      guard let concept = element as? Concept else {
        return []
      }

      return [concept]
    case .multipleSelectedElements(let elements):
      return elements.compactMap { $0 as? Concept }
    default:
      return []
    }
  }

  func currentSelectedLink() -> Link? {
    guard case let .selectedElement(element) = currentState, let link = element as? Link else {
      return nil
    }

    return link
  }

  func makeSelectedElementsBold() {
    for concept in currentSelectedConcepts() {
      concept.attributedStringValue = NSAttributedString(
        attributedString: concept.attributedStringValue, bold: !concept.attributedStringValue.isBold
      )
    }
  }

  func strikethroughSelectedElements() {
    for concept in currentSelectedConcepts() {
      concept.attributedStringValue = NSAttributedString(
        attributedString: concept.attributedStringValue,
        strikeThrough: !concept.attributedStringValue.isStrikedThrough
      )
    }
  }

  func makeSelectedElementsBigger() {
    for concept in currentSelectedConcepts() {
      concept.attributedStringValue = NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontSize: concept.attributedStringValue.fontSize + 3
      )
    }
  }

  func makeSelectedElementsSmaller() {
    for concept in currentSelectedConcepts() {
      concept.attributedStringValue = NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontSize: concept.attributedStringValue.fontSize - 3
      )
    }
  }

  func setColorForSelectedElements(fontColor color: NSColor) {
    if let link = currentSelectedLink() {
      link.color = color
    }

    for concept in currentSelectedConcepts() {
      concept.attributedStringValue = NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontColor: color
      )
    }
  }
}
