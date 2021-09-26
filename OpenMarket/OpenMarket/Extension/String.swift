//
//  String.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/16.
//

import UIKit

extension String {
    func redStrikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
}
