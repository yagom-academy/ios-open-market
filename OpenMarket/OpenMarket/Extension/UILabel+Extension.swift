import Foundation
import UIKit

extension UILabel {
    func strikeThrough() {
        guard let text = self.text else {
            return
        }
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0, length: attributeString.length))
        self.attributedText = attributeString
    }
}
