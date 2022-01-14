import Foundation
import UIKit

extension String {
    func eraseOriginalPrice() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(.foregroundColor,
                                     value: UIColor.systemRed,
                                     range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
}
