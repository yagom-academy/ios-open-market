//
//  String.swift
//  OpenMarket
//
//  Created by Hailey, Ryan-Son on 2021/05/29.
//

import Foundation
import UIKit.NSAttributedString

extension String {
    var strikeThrough: NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        return attributeString
    }
}
