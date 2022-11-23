//
//  applyStrikeThroughStyle+Extension.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/22.
//

import UIKit

extension UILabel {
    func applyStrikeThroughStyle() {
        let attributeString = NSMutableAttributedString(string: self.text ?? "")
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
}
