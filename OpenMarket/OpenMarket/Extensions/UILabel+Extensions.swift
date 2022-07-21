//
//  UILabel+Extensions.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/21.
//

import UIKit

extension UILabel {
    func strikethrough(from text: String?) {
        guard let text = text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
