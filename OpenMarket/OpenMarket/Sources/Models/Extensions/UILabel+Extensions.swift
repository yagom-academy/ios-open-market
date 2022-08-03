//
//  UILabel+Extensions.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/08/03.
//

import UIKit

extension UILabel {
    
    // MARK: - Actions
    
    func applyStrikethrough() {
        guard let text = self.text else {
            return
        }
        
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        attributedText = attributeString
    }
}
