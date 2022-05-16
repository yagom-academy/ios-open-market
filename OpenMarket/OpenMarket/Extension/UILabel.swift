//
//  UILabel+Extension.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/16.
//

import UIKit

extension UILabel {
    func addStrikeThrough(price: Double) {
        let underlineAttriString = NSAttributedString(
            string: String(price),
            attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        self.attributedText = underlineAttriString
    }
    
    func toDecimal(with currency: String, price: Double) {
        let numberfommater = NumberFormatter()
        numberfommater.numberStyle = .decimal

        guard let fomattedNumber = numberfommater.string(from: price as NSNumber) else {
            return
        }
        
        self.text = "\(currency) \(fomattedNumber)"
    }
}
