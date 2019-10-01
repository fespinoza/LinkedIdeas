import Cocoa

public struct DefaultColors {
  private static let bundle = Bundle(for: Concept.self)

  public static let color1 = Color(named: "label1", bundle: bundle)!
  public static let color2 = Color(named: "label2", bundle: bundle)!
  public static let color3 = Color(named: "label3", bundle: bundle)!
  public static let color4 = Color(named: "label4", bundle: bundle)!
  public static let color5 = Color(named: "label5", bundle: bundle)!
  public static let color6 = Color(named: "label6", bundle: bundle)!
  public static let color7 = Color(named: "label7", bundle: bundle)!

  public static let allColors = [color1, color2, color3, color4, color5, color6, color7]

  public static let linkColor = Color(named: "defaultLinkColor", bundle: bundle)!
}
