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

  // TODO: refactor this functions

  private func verticallyAlignLeftSelectedConcepts(isAlternate: Bool) {
    let selectedConcepts = currentSelectedConcepts()

    let conceptRects = selectedConcepts.map({ $0.rect })
    print(conceptRects.description)
    let alignedConceptRects = RectAlignments.verticallyLeftAlign(rects: conceptRects)
    print(alignedConceptRects.description)

    for (index, concept) in selectedConcepts.enumerated() {
      let newCenterPoint = alignedConceptRects[index].center
      document.move(concept: concept, toPoint: newCenterPoint)
    }

    if isAlternate {
      normalizeVerticalSpaceForSelectedConcepts()
    }
  }

  private func verticallyAlignCenterSelectedConcepts(isAlternate: Bool) {
    let selectedConcepts = currentSelectedConcepts()

    let conceptRects = selectedConcepts.map({ $0.rect })
    print(conceptRects.description)
    let alignedConceptRects = RectAlignments.verticallyCenterAlign(rects: conceptRects)
    print(alignedConceptRects.description)

    for (index, concept) in selectedConcepts.enumerated() {
      let newCenterPoint = alignedConceptRects[index].center
      document.move(concept: concept, toPoint: newCenterPoint)
    }

    if isAlternate {
      normalizeVerticalSpaceForSelectedConcepts()
    }
  }

  private func verticallyAlignRightSelectedConcepts(isAlternate: Bool) {
    let selectedConcepts = currentSelectedConcepts()

    let conceptRects = selectedConcepts.map({ $0.rect })
    let alignedConceptRects = RectAlignments.verticallyRightAlign(rects: conceptRects)

    for (index, concept) in selectedConcepts.enumerated() {
      let newCenterPoint = alignedConceptRects[index].center
      document.move(concept: concept, toPoint: newCenterPoint)
    }

    if isAlternate {
      normalizeVerticalSpaceForSelectedConcepts()
    }
  }

  private func horizontallyAlignCenterSelectedConcepts(isAlternate: Bool) {
    let selectedConcepts = currentSelectedConcepts()

    let conceptRects = selectedConcepts.map({ $0.rect })
    let alignedConceptRects = RectAlignments.horizontallyCenterAlign(rects: conceptRects)

    for (index, concept) in selectedConcepts.enumerated() {
      let newCenterPoint = alignedConceptRects[index].center
      document.move(concept: concept, toPoint: newCenterPoint)
    }

    if isAlternate {
      normalizeHorizontalSpaceForSelectedConcepts()
    }
  }

  private func normalizeVerticalSpaceForSelectedConcepts() {
    let selectedConcepts = currentSelectedConcepts()

    let conceptRects = selectedConcepts.map({ $0.rect })
    let alignedConceptRects = RectAlignments.equalVerticalSpace(rects: conceptRects)

    for (index, concept) in selectedConcepts.enumerated() {
      let newCenterPoint = alignedConceptRects[index].center
      document.move(concept: concept, toPoint: newCenterPoint)
    }
  }

  private func normalizeHorizontalSpaceForSelectedConcepts() {
    let selectedConcepts = currentSelectedConcepts()

    let conceptRects = selectedConcepts.map({ $0.rect })
    let alignedConceptRects = RectAlignments.equalHorizontalSpace(rects: conceptRects)

    for (index, concept) in selectedConcepts.enumerated() {
      let newCenterPoint = alignedConceptRects[index].center
      document.move(concept: concept, toPoint: newCenterPoint)
    }
  }
}
