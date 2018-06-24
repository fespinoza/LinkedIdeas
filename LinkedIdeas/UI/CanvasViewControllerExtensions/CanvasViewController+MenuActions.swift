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
    static let color2 = NSColor(red: 0/255, green: 75/255, blue: 213/255, alpha: 1.0)
    static let color3 = NSColor(red: 226/255, green: 6/255, blue: 6/255, alpha: 1.0)
    static let color4 = NSColor(red: 83/255, green: 153/255, blue: 6/255, alpha: 1.0)
    static let color5 = NSColor(red: 162/255, green: 8/255, blue: 174/255, alpha: 1.0)
    static let color6 = NSColor(red: 255/255, green: 95/255, blue: 0/255, alpha: 1.0)
    static let color7 = NSColor(red: 73/255, green: 9/255, blue: 152/255, alpha: 1.0)

    static let allColors = [color1, color2, color3, color4, color5, color6, color7]
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
