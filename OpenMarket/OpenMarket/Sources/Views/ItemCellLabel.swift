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

class PriceLabel: ItemCellLabel {
    enum State {
        case normal, discounted

        var attributes: [NSAttributedString.Key: Any]? {
            switch self {
            case .normal: return nil
            case .discounted: return [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            }
        }

        var textColor: UIColor? {
            switch self {
            case .normal: return nil
            case .discounted: return .systemRed
            }
        }
    }

    func setText(by state: State, _ currency: String, _ price: Int) {
        attributedText = NSAttributedString(string: "\(currency) \(price)", attributes: state.attributes)
        if let textColor = state.textColor {
            self.textColor = textColor
        }
    }
}
