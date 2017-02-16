//
//  WindowController.swift
//  LinkedIdeas
//
//  Created by Felipe Espinoza Castillo on 30/03/16.
//  Copyright © 2016 Felipe Espinoza Dev. All rights reserved.
//

import Cocoa

class OldWindowController: NSWindowController, AlignmentFunctions {

  @IBOutlet var ultraWindow: NSWindow!
  @IBOutlet weak var scrollView: NSScrollView!
  @IBOutlet weak var canvas: OldCanvasView!

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
    case left = 0
    case center = 1
    case right = 2
    case horizontal = 3
    case verticalSpacing = 4
    case horizontalSpacing = 5
  }

  enum FormatButtons: Int {
    case bold = 0
    case strikethrough = 1
  }

  override func windowDidLoad() {
    super.windowDidLoad()
    ultraWindow.acceptsMouseMovedEvents = true

    let currentDocument = document as! Document
    canvas.document = currentDocument
    canvas.frame = scrollView.bounds
    canvas.invalidateIntrinsicContentSize()
  }

  // MARK: - Keyboard Events
  override func keyDown(with theEvent: NSEvent) {
    if (theEvent.modifierFlags.contains(.shift)) {
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

  // MARK: - Text Format

  func toggleScratchText() {
    var scratchText: Bool = true
    canvas.selectedConcepts().forEach { concept in
      scratchText = scratchText && concept.attributedStringValue.isStrikedThrough
    }
    scratchText = !scratchText

    updateSelectedConceptsText { concept in
      NSAttributedString(
        attributedString: concept.attributedStringValue,
        strikeThrough: scratchText
      )
    }
  }

  func toggleBoldText() {
    var bold: Bool = true
    canvas.selectedConcepts().forEach { concept in
      bold = bold && concept.attributedStringValue.isBold
    }
    bold = !bold

    updateSelectedConceptsText { concept in
     NSAttributedString(
        attributedString: concept.attributedStringValue,
        bold: bold
      )
    }
  }

  // MARK: - Alignment

  func alignSelectedElements(_ alignment: Aligment) {
    let elements = canvas.selectedConcepts().map { $0 as SquareElement }

    switch alignment {
    case .left:
      verticallyLeftAlign(elements)
    case .center:
      verticallyCenterAlign(elements)
    case .right:
      verticallyRightAlign(elements)
    case .horizontal:
      horizontallyAlign(elements)
    case .verticalSpacing:
      equalVerticalSpace(elements)
    case .horizontalSpacing:
      equalHorizontalSpace(elements)
    }
  }

  func setNewPoint(_ newPoint: NSPoint, forElement element: SquareElement) {
    let concept = element as! Concept
    canvas.conceptViewFor(concept).textField.attributedStringValue = concept.attributedStringValue
    canvas.document.move(concept: concept, toPoint: newPoint)
  }

  func selectedElementsCallback() {
    let selectedConcepts = canvas.selectedConcepts()

    var selectedFontSize: Int?
    var selectedFontColor: NSColor?
    var isStrikethrough: Bool?
    var isBold: Bool?

    let fontSizes = Set(selectedConcepts.map { $0.attributedStringValue.fontSize })
    if fontSizes.count == 1 { selectedFontSize = fontSizes.first }

    let fontColors = Set(selectedConcepts.map { $0.attributedStringValue.fontColor })
    if fontColors.count == 1 { selectedFontColor = fontColors.first }

    let strikethroughs = Set(selectedConcepts.map { $0.attributedStringValue.isStrikedThrough })
    if strikethroughs.count == 1 { isStrikethrough = strikethroughs.first }

    let bolds = Set(selectedConcepts.map { $0.attributedStringValue.isBold })
    if bolds.count == 1 { isBold = bolds.first }

    if let selectedFontSize = selectedFontSize { fontSizeTextField.integerValue = selectedFontSize }
    if let selectedFontColor = selectedFontColor { colorSelector.color = selectedFontColor }

    if let isBold = isBold {
      formatTextButtons.setSelected(isBold, forSegment: FormatButtons.bold.rawValue)
    } else {
      formatTextButtons.setSelected(false, forSegment: FormatButtons.bold.rawValue)
    }

    if let isStrikethrough = isStrikethrough {
      formatTextButtons.setSelected(isStrikethrough, forSegment: FormatButtons.strikethrough.rawValue)
    } else {
      formatTextButtons.setSelected(false, forSegment: FormatButtons.strikethrough.rawValue)
    }
  }

  func updateSelectedConceptsText(_ neNSAttributedStringTranformation: (Concept) -> NSAttributedString) {
    for concept in canvas.selectedConcepts() {
      let newText = neNSAttributedStringTranformation(concept)
      canvas.conceptViewFor(concept).textField.attributedStringValue = newText
      concept.attributedStringValue = newText
    }
  }

  // MARK: - Pasteboard

  func writeToPasteboard(_ pasteboard: NSPasteboard) {
    guard canvas.selectedConcepts().count != 0 else { return }

    pasteboard.clearContents()
    pasteboard.writeObjects(canvas.selectedConcepts().map { $0.attributedStringValue })
  }

  func readFromPasteboard(_ pasteboard: NSPasteboard) -> Bool {
    let objects = pasteboard.readObjects(forClasses: [NSAttributedString.self], options: [:]) as! [NSAttributedString]

    guard objects.count != 0 else { return false }

    canvas.deselectConcepts()
    for (index, string) in objects.enumerated() {
      createConceptFromPasteboard(string, index: index)
    }
    return true
  }

  func readFromPasteboardAsPlainText(_ pasteboard: NSPasteboard) -> Bool {
    let objects = pasteboard.readObjects(
      forClasses: [NSString.self], options: [:]
      ) as! [String]

    guard objects.count != 0 else { return false }

    canvas.deselectConcepts()
    let splittedStrings = objects.first?.characters.split { $0 == "\n" }.map {
     NSAttributedString(string: String($0))
    }

    if let splittedStrings = splittedStrings {
      for (index, string) in splittedStrings.enumerated() {
        createConceptFromPasteboard(string, index: index)
      }
      return true
    } else {
      return false
    }
  }

  func createConceptFromPasteboard(_ attributedString: NSAttributedString, index: Int) {
    let newConceptPadding: Int = 30
    let newPoint = NSPoint(
      x: CGFloat(200+(newConceptPadding*index)),
      y: CGFloat(200+(newConceptPadding*index))
    )
    let concept = Concept(attributedStringValue: attributedString, point: newPoint)
    concept.isSelected = true
    canvas.justSaveConcept(concept)
  }

  // MARK: - Interface Actions

  @IBAction func changeMode(_ sender: NSSegmentedControl) {
    switch sender.selectedSegment {
    case 1:
      editionMode = .Concepts
    case 2:
      editionMode = .Links
    default:
      editionMode = .Select
    }
    canvas.mode = editionMode
  }

  @IBAction func selectColor(_ sender: AnyObject) {
    let newColor = colorSelector.color

    updateSelectedConceptsText { concept in
     NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontColor: newColor
      )
    }

    let selectedLinks = canvas.links.filter { $0.isSelected }
    for link in selectedLinks {
      link.color = newColor
      canvas.linkViewFor(link).needsDisplay = true
    }
  }

  @IBAction func formatSelectedTexts(_ sender: NSSegmentedControl) {
    if let format = FormatButtons(rawValue: sender.selectedSegment) {
      switch format {
      case .bold:
        toggleBoldText()
      case .strikethrough:
        toggleScratchText()
      }
    }
  }

  @IBAction func updateFontSize(_ sender: AnyObject) {
    updateSelectedConceptsText { concept in
     NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontSize: self.fontSizeTextField.integerValue
      )
    }
  }

  @IBAction func alignElements(_ sender: NSSegmentedControl) {
    if let alignment = Aligment(rawValue: sender.selectedSegment) {
      alignSelectedElements(alignment)
    }
  }

  @IBAction func cut(_ sender: AnyObject?) {
    writeToPasteboard(NSPasteboard.general())
    canvas.removeSelectedConceptViews()
  }

  @IBAction func copy(_ sender: AnyObject?) {
    writeToPasteboard(NSPasteboard.general())
  }

  @IBAction func paste(_ sender: AnyObject?) {
    let _ = readFromPasteboard(NSPasteboard.general())
  }

  @IBAction func pasteAsPlainText(_ sender: AnyObject?) {
    let _ = readFromPasteboardAsPlainText(NSPasteboard.general())
  }

  @IBAction func addFontTrait(_ sender: AnyObject?) {
    let title = (sender as? NSMenuItem)?.title

    guard title != nil else {
      NSFontManager.shared().addFontTrait(sender)
      return
    }

    switch title! {
    case "Bold":
      toggleBoldText()
    case "Strikethrough":
      toggleScratchText()
    default:
      NSFontManager.shared().addFontTrait(sender)
    }
  }
}
