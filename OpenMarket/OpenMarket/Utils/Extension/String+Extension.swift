import Foundation
import UIKit

extension String {
    func eraseOriginalPrice() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttributes(
            [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.systemRed
            ],
            range: NSRange(location: 0, length: attributeString.length)
        )
        return attributeString
    }
}
