//
//  WindowController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 30/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController, AlignmentFunctions {

  @IBOutlet var ultraWindow: NSWindow!
  @IBOutlet weak var scrollView: NSScrollView!
  @IBOutlet weak var canvas: CanvasView!

  @IBOutlet weak var modeSelector: NSSegmentedControl!

  @IBOutlet weak var aligmentButtons: NSSegmentedControl!

  @IBOutlet weak var colorSelector: NSColorWell!
  @IBOutlet weak var formatTextButtons: NSSegmentedControl!
  @IBOutlet weak var fontSizeTextField: NSTextField!
  @IBOutlet weak var fontSizeStepper: NSStepper!

  dynamic var selectedColor: NSColor = Link.defaultColor
  var editionMode = Mode.Concepts

  let numberOne: UInt16 = 18
  let numberTwo: UInt16 = 19
  let numberThree: UInt16 = 20
  let numberFour: UInt16 = 21
  let numberFive: UInt16 = 22
  let numberSix: UInt16  = 23

  dynamic var fontSize: Int = 12

  enum Aligment: Int {
    case Left = 0
    case Center = 1
    case Right = 2
    case Horizontal = 3
    case VerticalSpacing = 4
    case HorizontalSpacing = 5
  }

  enum FormatButtons: Int {
    case Bold = 0
    case Strikethrough = 1
  }

  convenience init() {
    self.init(window: nil)
  }

  override init(window: NSWindow?) {
    super.init(window: window)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    ultraWindow.acceptsMouseMovedEvents = true

    let currentDocument = document as! Document
    canvas.document = currentDocument
    canvas.frame = scrollView.bounds
  }

  // MARK: - Keyboard Events
  override func keyDown(theEvent: NSEvent) {
    if (theEvent.modifierFlags.contains(.ShiftKeyMask)) {
      let index: Int = Int(theEvent.keyCode) - Int(numberOne)
      if let aligment = Aligment(rawValue: index) {
        alignSelectedElements(aligment)
      }
    } else {
      switch theEvent.keyCode {
      case numberOne:
        canvas.mode = .Select
        modeSelector.selectedSegment = 0
      case numberTwo:
        canvas.mode = .Concepts
        modeSelector.selectedSegment = 1
      case numberThree:
        canvas.mode = .Links
        modeSelector.selectedSegment = 2
      default: break
      }
    }
  }

  @IBAction func changeMode(sender: NSSegmentedControl) {
    switch sender.doubleValueForSelectedSegment {
    case 1:
      editionMode = .Concepts
    case 2:
      editionMode = .Links
    default:
      editionMode = .Select
    }
    canvas.mode = editionMode
  }

  func toggleScratchText() {
    var scratchText: Bool = true
    canvas.selectedConcepts().forEach { concept in
      scratchText = scratchText && concept.attributedStringValue.isStrikedThrough
    }
    scratchText = !scratchText

    for concept in canvas.selectedConcepts() {
      let newText = NSAttributedString(
        attributedString: concept.attributedStringValue,
        strikeThrough: scratchText
      )

      canvas.conceptViewFor(concept).textField.attributedStringValue = newText
      concept.attributedStringValue = newText
    }
  }

  func toggleBoldText() {
    var bold: Bool = true
    canvas.selectedConcepts().forEach { concept in
      bold = bold && concept.attributedStringValue.isBold
    }
    bold = !bold

    for concept in canvas.selectedConcepts() {
      let newText = NSAttributedString(
        attributedString: concept.attributedStringValue,
        bold: bold
      )

      canvas.conceptViewFor(concept).textField.attributedStringValue = newText
      concept.attributedStringValue = newText
    }
  }

  @IBAction func selectColor(sender: AnyObject) {
    let newColor = colorSelector  .color
    let selectedLinks = canvas.links.filter { $0.isSelected }
    for link in selectedLinks {
      link.color = newColor
      canvas.linkViewFor(link).needsDisplay = true
    }
  }

  func alignSelectedElements(alignment: Aligment) {
    let elements = canvas.selectedConcepts().map { $0 as SquareElement }

    switch alignment {
    case .Left:
      verticallyLeftAlign(elements)
    case .Center:
      verticallyCenterAlign(elements)
    case .Right:
      verticallyRightAlign(elements)
    case .Horizontal:
      horizontallyAlign(elements)
    case .VerticalSpacing:
      equalVerticalSpace(elements)
    case .HorizontalSpacing:
      equalHorizontalSpace(elements)
    }
  }

  @IBAction func formatSelectedTexts(sender: NSSegmentedControl) {
    if let format = FormatButtons(rawValue: sender.selectedSegment) {
      switch format {
      case .Bold:
        toggleBoldText()
      case .Strikethrough:
        toggleScratchText()
      }
    }
  }

  @IBAction func stepFontSize(sender: NSStepper) {
    // Update selected text font size
  }

  @IBAction func alignElements(sender: NSSegmentedControl) {
    if let alignment = Aligment(rawValue: sender.selectedSegment) {
      alignSelectedElements(alignment)
    }
  }

  func setNewPoint(newPoint: NSPoint, forElement element: SquareElement) {
    let concept = element as! Concept
    canvas.conceptViewFor(concept).textField.attributedStringValue = concept.attributedStringValue
    canvas.document.changeConceptPoint(concept, fromPoint: concept.point, toPoint: newPoint)
  }

  func selectedElementsCallback() {
  }
}

extension NSAttributedString {
  var maxRange: NSRange { return NSMakeRange(0, length) }
  var isStrikedThrough: Bool {
    get {
      var range = maxRange
      let strikeValue = attribute(NSStrikethroughStyleAttributeName, atIndex: 0, effectiveRange: &range) as? Int
      return strikeValue == NSUnderlineStyle.StyleSingle.rawValue
    }
  }

  convenience init(attributedString: NSAttributedString, strikeThrough:Bool) {
    var strikeStyle: NSUnderlineStyle = NSUnderlineStyle.StyleNone
    if strikeThrough { strikeStyle = NSUnderlineStyle.StyleSingle }

    let _tempCopy = attributedString.mutableCopy()
    _tempCopy.addAttribute(
      NSStrikethroughStyleAttributeName,
      value: strikeStyle.rawValue,
      range: attributedString.maxRange
    )
    self.init(attributedString: _tempCopy as! NSAttributedString)
  }

  var isBold: Bool {
    var range = maxRange
    let font = attribute(NSFontAttributeName, atIndex: 0, effectiveRange: &range) as? NSFont

    if let font = font {
      return (font.fontDescriptor.symbolicTraits & UInt32(NSFontTraitMask.BoldFontMask.rawValue)) != 0
    }

    return false
  }

  convenience init(attributedString: NSAttributedString, bold:Bool) {
    var range = attributedString.maxRange
    let font = attributedString.attribute(NSFontAttributeName, atIndex: 0, effectiveRange: &range) as? NSFont
    var newFont: NSFont = NSFont(name: "Helvetica", size: 12)!

    if let font = font { newFont = font }

    if bold {
      newFont = NSFontManager.sharedFontManager().convertFont(newFont, toHaveTrait: .BoldFontMask)
    } else {
      newFont = NSFontManager.sharedFontManager().convertFont(newFont, toNotHaveTrait: .BoldFontMask)
    }

    let _tempCopy = attributedString.mutableCopy()
    _tempCopy.addAttribute(
      NSFontAttributeName,
      value: newFont,
      range: attributedString.maxRange
    )

    self.init(attributedString: _tempCopy as! NSAttributedString)
  }
}
