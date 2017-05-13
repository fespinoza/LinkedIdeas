//
//  CanvasViewController+MenuActions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 11/05/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

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
    static let color2 = NSColor.red
    static let color3 = NSColor.blue
    static let color4 = NSColor.green
    static let color5 = NSColor.purple
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
    default:
      break
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
      return elements.flatMap { $0 as? Concept }
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
        fontSize: concept.attributedStringValue.fontSize + 1
      )
    }
  }

  func makeSelectedElementsSmaller() {
    for concept in currentSelectedConcepts() {
      concept.attributedStringValue = NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontSize: concept.attributedStringValue.fontSize - 1
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
