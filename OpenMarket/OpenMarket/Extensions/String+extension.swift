import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        let totalRange = NSRange(location: 0, length: attributeString.length)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: totalRange)
        attributeString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: totalRange)
        return attributeString
    }
}
