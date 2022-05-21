//
//  String+.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/19.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributedString.length)
        )
        return attributedString
    }
}
