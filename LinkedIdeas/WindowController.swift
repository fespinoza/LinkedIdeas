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
    canvas.invalidateIntrinsicContentSize()
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
  
  func setNewPoint(newPoint: NSPoint, forElement element: SquareElement) {
    let concept = element as! Concept
    canvas.conceptViewFor(concept).textField.attributedStringValue = concept.attributedStringValue
    canvas.document.changeConceptPoint(concept, fromPoint: concept.point, toPoint: newPoint)
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
      formatTextButtons.setSelected(isBold, forSegment: FormatButtons.Bold.rawValue)
    } else {
      formatTextButtons.setSelected(false, forSegment: FormatButtons.Bold.rawValue)
    }
    
    if let isStrikethrough = isStrikethrough {
      formatTextButtons.setSelected(isStrikethrough, forSegment: FormatButtons.Strikethrough.rawValue)
    } else {
      formatTextButtons.setSelected(false, forSegment: FormatButtons.Strikethrough.rawValue)
    }
  }
  
  func updateSelectedConceptsText(newAttributedStringTranformation: (Concept) -> NSAttributedString) {
    for concept in canvas.selectedConcepts() {
      let newText = newAttributedStringTranformation(concept)
      canvas.conceptViewFor(concept).textField.attributedStringValue = newText
      concept.attributedStringValue = newText
    }
  }
  
  
  // MARK: - Pasteboard
  
  func writeToPasteboard(pasteboard: NSPasteboard) {
    guard canvas.selectedConcepts().count != 0 else { return }
    
    pasteboard.clearContents()
    pasteboard.writeObjects(canvas.selectedConcepts().map { $0.attributedStringValue })
  }
  
  func readFromPasteboard(pasteboard: NSPasteboard) -> Bool {
    let objects = pasteboard.readObjectsForClasses(
      [NSAttributedString.self], options: [:]
      ) as! [NSAttributedString]
    
    guard objects.count != 0 else { return false }
    
    canvas.deselectConcepts()
    for (index, string) in objects.enumerate() {
      createConceptFromPasteboard(string, index: index)
    }
    return true
  }
  
  func readFromPasteboardAsPlainText(pasteboard: NSPasteboard) -> Bool {
    let objects = pasteboard.readObjectsForClasses(
      [NSString.self], options: [:]
      ) as! [String]
    
    guard objects.count != 0 else { return false }
    
    canvas.deselectConcepts()
    let splittedStrings = objects.first?.characters.split { $0 == "\n" }.map {
      NSAttributedString(string: String($0))
    }
    
    if let splittedStrings = splittedStrings {
      for (index, string) in splittedStrings.enumerate() {
        createConceptFromPasteboard(string, index: index)
      }
      return true
    } else {
      return false
    }
  }
  
  func createConceptFromPasteboard(attributedString: NSAttributedString, index: Int) {
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
  
  @IBAction func changeMode(sender: NSSegmentedControl) {
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

  @IBAction func selectColor(sender: AnyObject) {
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

  @IBAction func updateFontSize(sender: AnyObject) {
    updateSelectedConceptsText { concept in
      NSAttributedString(
        attributedString: concept.attributedStringValue,
        fontSize: self.fontSizeTextField.integerValue
      )
    }
  }

  @IBAction func alignElements(sender: NSSegmentedControl) {
    if let alignment = Aligment(rawValue: sender.selectedSegment) {
      alignSelectedElements(alignment)
    }
  }

  @IBAction func cut(sender: AnyObject?) {
    writeToPasteboard(NSPasteboard.generalPasteboard())
    canvas.removeSelectedConceptViews()
  }
  
  @IBAction func copy(sender: AnyObject?) {
    writeToPasteboard(NSPasteboard.generalPasteboard())
  }
  
  @IBAction func paste(sender: AnyObject?) {
    readFromPasteboard(NSPasteboard.generalPasteboard())
  }
  
  @IBAction func pasteAsPlainText(sender: AnyObject?) {
    readFromPasteboardAsPlainText(NSPasteboard.generalPasteboard())
  }
}