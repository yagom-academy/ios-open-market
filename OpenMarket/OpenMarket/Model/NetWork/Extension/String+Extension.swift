import Foundation
import UIKit

extension String {
    var redStrikeThroughStyle: NSMutableAttributedString {
        let atrributedString = NSMutableAttributedString(string: self)
        atrributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, atrributedString.length))
        atrributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, atrributedString.length))
        return atrributedString
    }
    
    var grayColor: NSMutableAttributedString {
        let atrributedString = NSMutableAttributedString(string: self)
        atrributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGray, range: NSMakeRange(0, atrributedString.length))
        return atrributedString
    }
  
    var yellowColor: NSMutableAttributedString {
        let atrributedString = NSMutableAttributedString(string: self)
        atrributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSMakeRange(0, atrributedString.length))
        return atrributedString
    }
    
    var boldFont: NSMutableAttributedString {
        let atrributedString = NSMutableAttributedString(string: self)
        atrributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 15), range: NSMakeRange(0, atrributedString.length))
        return atrributedString
    }
}

// MARK: Numberformatter Extension

extension String {
    var decimal: String? {
        guard let number = Double(self) else {
            return nil
        }
        let numberformatter = NumberFormatter()
        numberformatter.numberStyle = .decimal
        return numberformatter.string(from: NSNumber(value: number))
    }
}



