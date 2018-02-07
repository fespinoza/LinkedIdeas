//
//  DocumentManager.swift
//  QuickLookTestGenerator
//
//  Created by Felipe Espinoza Castillo on 27/02/2017.
//  Copyright © 2017 Felipe Espinoza Castillo. All rights reserved.
//

import Cocoa
import LinkedIdeas_Shared

private extension String {
  static let documentDataClassName = "LinkedIdeas.DocumentData"
  static let conceptClassName = "LinkedIdeas.Concept"
  static let linkClassName = "LinkedIdeas.Link"
}

public class DocumentManager: NSObject {
  @objc public var url: URL?
  @objc public var contentTypeUTI: String?

  @objc override public var description: String {
    return "DocumentManager: url=\(String(describing: url)) uti=\(String(describing: contentTypeUTI))"
  }

  @objc public func processDocument(canvasSize: CGSize, context: NSGraphicsContext) {
    guard let url = url, let contentTypeUTI = contentTypeUTI else {
      return
    }

    do {
      NSKeyedUnarchiver.setClass(DocumentData.self, forClassName: .documentDataClassName)
      NSKeyedUnarchiver.setClass(Concept.self, forClassName: .conceptClassName)
      NSKeyedUnarchiver.setClass(Link.self, forClassName: .linkClassName)

      let document: Document = try Document(contentsOf: url, ofType: contentTypeUTI)
      let frame = document.rect

      // Changes the origin of the user coordinate system in a context.
      // so the preview is shown from the 0.0 coorinate for the canvas
      context.cgContext.translateBy(x: -frame.origin.x, y: -frame.origin.y)

      let canvasView = CanvasView(frame: frame)

      canvasView.dataSource = document

      canvasView.displayIgnoringOpacity(frame, in: context)
    } catch {
      Swift.print("error :(")
    }
  }
}
