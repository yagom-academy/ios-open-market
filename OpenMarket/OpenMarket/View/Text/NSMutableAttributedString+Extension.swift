import UIKit

extension NSMutableAttributedString {
    
    func adjustDecimal() {
        guard let number = Double(self.string) else {
            return
        }
        
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        guard let string = numberformatter.string(from: NSNumber(value: number)) else {
            return
        }
        
        self.setAttributedString(NSMutableAttributedString(string: string))
    }

    func adjustStrikeThrough() {
        self.addAttribute(.strikethroughStyle,
                          value: NSUnderlineStyle.single.rawValue,
                          range: NSMakeRange(0, self.length))
    }
    
    func changeColor(to color: UIColor) {
        self.addAttribute(NSAttributedString.Key.foregroundColor,
                          value: color,
                          range: NSMakeRange(0, self.length))
    }
    
    func adjustTextStyle(textStyle: UIFont.TextStyle) {
        let font = UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: nil)
        self.addAttribute(.font, value: font, range: NSMakeRange(0, self.length))
    }
}
