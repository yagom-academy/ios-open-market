//
//  OpenMarket - String+Extension.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import UIKit

extension String {
    func strikeThrough(length: Int, color: UIColor) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, length))
        attributeString.addAttributes([NSAttributedString.Key.foregroundColor : color],
                                      range: NSMakeRange(0, length))
        return attributeString
    }
}
