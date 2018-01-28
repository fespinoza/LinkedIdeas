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

//dump(document.concepts)

// - calculate "document size"
// - add canvas to a scrollable area
// - allow each concept to render itself

public protocol CanvasViewDataSource {
  func drawableElements(forRect: CGRect) -> [DrawableConcept]
}

public class CanvasView: UIView {
  // MARK: - public properties
  var dataSource: CanvasViewDataSource? {
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

struct SimpleDataSource: CanvasViewDataSource {
  let concepts: [Concept]

  func drawableElements(forRect rect: CGRect) -> [DrawableConcept] {
    print(#function, rect)
    return concepts.filter({ $0.area.intersects(rect) })
                   .flatMap({ DrawableConcept(concept: $0) })
  }
}


let canvasFrame = CGRect(x: 0, y: 0, width: 3000, height: 2000)
let phoneFrame = CGRect(x: 0, y: 0, width: 375, height: 667)

let scrollView = UIScrollView(frame: phoneFrame)
scrollView.contentSize = canvasFrame.size
scrollView.backgroundColor = .red

let canvasView = CanvasView(frame: canvasFrame)
canvasView.dataSource = SimpleDataSource(concepts: document.concepts)

scrollView.addSubview(canvasView)

PlaygroundPage.current.liveView = scrollView

//: [Next](@next)
