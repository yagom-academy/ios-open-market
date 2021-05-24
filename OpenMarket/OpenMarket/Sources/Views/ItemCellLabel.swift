//
//  ItemCellLabel.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemCellLabel: UILabel {
    private var baseTextColor: UIColor?

    init(textStyle: UIFont.TextStyle = .body, textColor: UIColor? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: textStyle)
        self.textColor = textColor
        baseTextColor = textColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func reset() {
        attributedText = nil
        textColor = baseTextColor
    }
}
