import UIKit

extension NSMutableAttributedString {
    
    var toDecimal: NSMutableAttributedString? {
        guard let number = Double(self.string) else {
            return nil
        }
        
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        guard let string = numberformatter.string(from: NSNumber(value: number)) else {
            return nil
        }
        
        return NSMutableAttributedString(string: string)
    }

    func setStrikeThrough() {
        self.addAttribute(.strikethroughStyle,
                          value: NSUnderlineStyle.single.rawValue,
                          range: NSMakeRange(0, self.length))
    }
    
    func setFontColor(to color: UIColor) {
        self.addAttribute(NSAttributedString.Key.foregroundColor,
                          value: color,
                          range: NSMakeRange(0, self.length))
    }
    
    func setTextStyle(textStyle: UIFont.TextStyle) {
        let font = UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: nil)
        self.addAttribute(.font, value: font, range: NSMakeRange(0, self.length))
    }
}
