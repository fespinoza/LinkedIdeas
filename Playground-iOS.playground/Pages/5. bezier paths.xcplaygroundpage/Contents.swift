//: [Previous](@previous)

import Foundation
import UIKit

var str = "Hello, playground"


let bezierPath = UIBezierPath()
bezierPath.move(to: CGPoint(x: 100, y: 0))
bezierPath.addLine(to: CGPoint(x: 100, y: 100))
bezierPath.addLine(to: CGPoint(x: 200, y: 0))
bezierPath.close()
bezierPath.stroke()

//: [Next](@next)
