//
//  Extenstion + String.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/20.
//

import UIKit

extension String {
    func strikethrough() -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
