//
//  StrockLabel.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

protocol StrockText {
    func strockLabel(item: String, label: UILabel) -> UILabel
}

extension StrockText {
    func strockLabel(item: String, label: UILabel) -> UILabel {
        let attributeString = NSMutableAttributedString(string: item)
        attributeString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        label.attributedText = attributeString
        label.textColor = .systemRed
        return label
    }
}
