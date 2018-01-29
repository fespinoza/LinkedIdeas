import LinkedIdeas_iOS_Core
import LinkedIdeas_Shared

public protocol CanvasViewDataSource {
  func drawableElements(forRect: CGRect) -> [DrawableConcept]
}

public class CanvasView: UIView {
  // MARK: - public properties
  public var dataSource: CanvasViewDataSource? {
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

public struct SimpleDataSource: CanvasViewDataSource {
  let concepts: [Concept]

  public func drawableElements(forRect rect: CGRect) -> [DrawableConcept] {
    print(#function, rect)
    return concepts.filter({ $0.area.intersects(rect) })
      .flatMap({ DrawableConcept(concept: $0) })
  }
}


public extension Document {
  public func documentFocusRect() -> CGRect {
    return concepts.map({ $0.area })
            .reduce(nil) { (result, newRect) -> CGRect? in
              if let result = result {
                return result.union(newRect)
              } else {
                return newRect
              }
            } ?? CGRect.zero
  }
}
