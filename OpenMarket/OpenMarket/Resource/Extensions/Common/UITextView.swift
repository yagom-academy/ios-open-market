//
//  UITextView.swift
//  OpenMarket
//
//  Created by baem, mini on 2022/12/07.
//

import UIKit

extension UITextView {
    convenience init(
        text: String,
        textColor: UIColor,
        font: UIFont,
        spellCheckingType: UITextSpellCheckingType
    ) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.spellCheckingType = spellCheckingType
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
