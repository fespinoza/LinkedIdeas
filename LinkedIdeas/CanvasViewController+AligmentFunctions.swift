//
//  CanvasViewController+AligmentFunctions.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 08/06/2017.
//  Copyright © 2017 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

extension CanvasViewController {
  private enum AligmentMenu: Int {
    case verticallyLeft
    case verticallyCenter
    case verticallyRight
    case horizontallyCenter
    case equalVerticalSpace
    case equalHorizontalSpace
  }

  @IBAction func customAlignElements(_ sender: Any) {
    guard let item = sender as? NSMenuItem,
          let aligmentCase = AligmentMenu(rawValue: item.tag) else {
            return
          }

    switch aligmentCase {
    case .verticallyLeft:
      verticallyAlignLeftSelectedConcepts(isAlternate: item.isAlternate)
    case .verticallyCenter:
      verticallyAlignCenterSelectedConcepts(isAlternate: item.isAlternate)
    case .verticallyRight:
      verticallyAlignRightSelectedConcepts(isAlternate: item.isAlternate)
    case .horizontallyCenter:
      horizontallyAlignCenterSelectedConcepts(isAlternate: item.isAlternate)
    case .equalVerticalSpace:
      normalizeVerticalSpaceForSelectedConcepts()
    case .equalHorizontalSpace:
      normalizeHorizontalSpaceForSelectedConcepts()
    }
  }

  private func verticallyAlignLeftSelectedConcepts(isAlternate: Bool) {
    applyToSelectedConcepts(alignmentFunction: RectAlignments.verticallyLeftAlign)

    if isAlternate {
      normalizeVerticalSpaceForSelectedConcepts()
    }
  }

  private func verticallyAlignCenterSelectedConcepts(isAlternate: Bool) {
    applyToSelectedConcepts(alignmentFunction: RectAlignments.verticallyCenterAlign)

    if isAlternate {
      normalizeVerticalSpaceForSelectedConcepts()
    }
  }

  private func verticallyAlignRightSelectedConcepts(isAlternate: Bool) {
    applyToSelectedConcepts(alignmentFunction: RectAlignments.verticallyRightAlign)

    if isAlternate {
      normalizeVerticalSpaceForSelectedConcepts()
    }
  }

  private func horizontallyAlignCenterSelectedConcepts(isAlternate: Bool) {
    applyToSelectedConcepts(alignmentFunction: RectAlignments.horizontallyCenterAlign)

    if isAlternate {
      normalizeHorizontalSpaceForSelectedConcepts()
    }
  }

  private func normalizeVerticalSpaceForSelectedConcepts() {
    applyToSelectedConcepts(alignmentFunction: RectAlignments.equalVerticalSpace)
  }

  private func normalizeHorizontalSpaceForSelectedConcepts() {
    applyToSelectedConcepts(alignmentFunction: RectAlignments.equalHorizontalSpace)
  }

  private func applyToSelectedConcepts(alignmentFunction: ([NSRect]) -> [NSRect]) {
    let selectedConcepts = currentSelectedConcepts()

    let conceptRects = selectedConcepts.map({ $0.rect })
    let alignedConceptRects = alignmentFunction(conceptRects)

    for (index, concept) in selectedConcepts.enumerated() {
      let newCenterPoint = alignedConceptRects[index].center
      document.move(concept: concept, toPoint: newCenterPoint)
    }
  }
}
