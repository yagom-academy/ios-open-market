//
//  ItemCellLabel.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemCellLabel: UILabel {
    init(textStyle: UIFont.TextStyle = .body, alpha: CGFloat = 1.0) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = .preferredFont(forTextStyle: textStyle)
        self.alpha = alpha
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
