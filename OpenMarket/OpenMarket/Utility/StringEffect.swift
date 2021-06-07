//
//  StringEffect.swift
//  OpenMarket
//
//  Created by 황인우 on 2021/06/07.
//

import Foundation
import UIKit

extension String {
    
    // MARK: - UIText effect
    
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
