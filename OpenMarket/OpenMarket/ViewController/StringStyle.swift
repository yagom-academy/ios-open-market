//
//  StringStyle.swift
//  OpenMarket
//
//  Created by ysp on 2021/06/10.
//

import UIKit

extension String {
    func attributedStrikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
