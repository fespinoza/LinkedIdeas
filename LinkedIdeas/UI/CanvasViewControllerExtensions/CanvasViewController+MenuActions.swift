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

extension CanvasViewController {

  override func selectAll(_ sender: Any?) {
    safeTransiton {
      try stateManager.toMultipleSelectedElements(elements: document.concepts)
    }
  }

  override func changeFont(_ sender: Any?) {
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

  struct DefaultColors {
    static let color1 = NSColor.black
    static let color2 = NSColor(fullRed: 0, fullGreen: 75, fullBlue: 213)
    static let color3 = NSColor(fullRed: 226, fullGreen: 6, fullBlue: 6)
    static let color4 = NSColor(fullRed: 83, fullGreen: 153, fullBlue: 6)
    static let color5 = NSColor(fullRed: 162, fullGreen: 8, fullBlue: 174)
    static let color6 = NSColor(fullRed: 255, fullGreen: 95, fullBlue: 0)
    static let color7 = NSColor(fullRed: 73, fullGreen: 9, fullBlue: 152)
  }

  override func changeColor(_ sender: Any?) {
    guard let menuItem = sender as? NSMenuItem else {
      return
    }

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

  @objc func zoomImageToActualSize(_ sender: Any?) {
    self.scrollView.setMagnification(1.0, centeredAt: self.scrollView.visibleRect.center)
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
    for concept in currentSelectedConcepts() {
      concept.attributedStringValue = NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontColor: color
      )
    }
  }
}
