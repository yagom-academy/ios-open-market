import UIKit

extension UIFont {
    static func dynamicBoldSystemFont(ofSize fontSize: CGFloat) -> UIFont {
        let font = boldSystemFont(ofSize: fontSize)
        return UIFontMetrics.default.scaledFont(for: font)
    }
}
