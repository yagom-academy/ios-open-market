//
//  ItemCellLabel.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemCellLabel: UILabel {
    fileprivate enum Style {
        static let discountedPriceAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        static let discountedPriceTextColor: UIColor = .systemRed
        static let inStockText: String = "잔여수량 : "
        static let soldOutText: String = "품절"
        static let soldOutTextColor: UIColor = .systemOrange
        static let stockBounds: Int = 99
    }

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
    }

    func setText(by state: State, _ currency: String, _ price: Int) {
        switch state {
        case .normal:
            text = "\(currency) \(price)"
        case .discounted:
            attributedText = NSAttributedString(string: "\(currency) \(price)", attributes: Style.discountedPriceAttribute)
            textColor = Style.discountedPriceTextColor
        }
    }
}

class StockLabel: ItemCellLabel {
    private var state: State = .soldOut

    enum State {
        case inStock, soldOut
    }

    func setText(_ stock: Int) {
        state = stock > 0 ? .inStock : .soldOut

        switch state {
        case .inStock:
            text = Style.inStockText + (stock > Style.stockBounds ? "\(Style.stockBounds)+" : "\(stock)")
        case .soldOut:
            text = Style.soldOutText
            textColor = Style.soldOutTextColor
        }
    }
}
