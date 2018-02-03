//: [Previous](@previous)

import UIKit
import LinkedIdeas_iOS_Core
import LinkedIdeas_Shared
import PlaygroundSupport

guard let url = Bundle.main.url(forResource: "sample-doc", withExtension: "idea"),
  let data = try? Data(contentsOf: url) else {
    preconditionFailure("i should be able to read the doc")
}

let document = Document(fileURL: url)
try? document.load(fromContents: data, ofType: "idea")


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
    scrollView.minimumZoomScale = 0.5
    scrollView.maximumZoomScale = 3.0
    scrollView.delegate = self

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

    let rect = document.documentFocusRect()
    scrollView.setContentOffset(rect.origin, animated: false)
  }
}

extension DocumentViewController: UIScrollViewDelegate {
  public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return canvasView
  }
}

extension DocumentViewController: CanvasViewDataSource {
  public func drawableElements(forRect rect: CGRect) -> [DrawableConcept] {
    return document.concepts
                   .filter({ $0.area.intersects(rect) })
                   .flatMap({ DrawableConcept(concept: $0) })
  }
}

let documentVC = DocumentViewController()
documentVC.document = document
let pair = playgroundControllers(device: .phone5_5inch, orientation: .portrait, child: documentVC)

PlaygroundPage.current.liveView = pair.parent

//: [Next](@next)
