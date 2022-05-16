//
//  UILabel+Extension.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/16.
//

import UIKit

extension UILabel {
    func addStrikeThrough() {
        guard let text = self.text else {
            return
        }
        
        let underlineAttriString = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        self.attributedText = underlineAttriString
    }
    
    func toDecimal(with currency: String) {
        let numberfommater = NumberFormatter()
        numberfommater.numberStyle = .decimal
        
        guard let text = self.text else {
            return
        }
    
        guard let number = numberfommater.number(from: text) else {
            return
        }
        
        guard let fomattedNumber = numberfommater.string(from: number) else {
            return
        }
        
        self.text = "\(currency) \(fomattedNumber)"
    }
}
