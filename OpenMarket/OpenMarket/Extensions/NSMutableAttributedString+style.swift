import UIKit

extension NSMutableAttributedString {
    static func strikeThroughStyle(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([
            NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor: UIColor.systemRed
        ], range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
    
    static func normalStyle(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: NSRange(location: 0, length: attributedString.length))
    
        return attributedString
    }
}
