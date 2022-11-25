//  String+.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/25.

import UIKit

extension String {
    func invalidatePrice() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor: UIColor.red], range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func markSoldOut() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
