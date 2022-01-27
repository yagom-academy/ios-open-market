//
//  UILabel+Extensions.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/27.
//

import UIKit.UILabel

extension UILabel {
    func convertToAttributedString(from label: UILabel) -> NSMutableAttributedString? {
        guard let priceLabelString = label.text else {
            return nil
        }
        let attributeString = NSMutableAttributedString(string: priceLabelString)
        let range = NSRange(location: 0, length: attributeString.length)
        attributeString.addAttribute(.strikethroughStyle, value: 1, range: range)
        
        return attributeString
    }
}
