//
//  String+Extension.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/21.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
