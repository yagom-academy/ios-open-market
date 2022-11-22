//
//  PriceLabel.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/22.
//

import UIKit

class PriceLabel: UILabel {
    private var currency: Currency = .krw
    @PositiveNumber private var price: Double
    @PositiveNumber private var bargainPrice: Double
    
    init() {
        super.init(frame: .zero)
        configure()
        setText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPrice(_ price: Double, bargainPrice: Double, currency: Currency) {
        self.price = price
        self.bargainPrice = bargainPrice
        self.currency = currency
        setText()
    }
    
    private func configure() {
        font = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory = true
        textAlignment = .left
        textColor = .gray
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setText() {
        let priceText: String = "\(currency.rawValue) \(price)"
        let bargainPriceText: String = "\(currency.rawValue) \(bargainPrice)"
        if price == bargainPrice {
            text = "\(bargainPriceText)"
        } else {
            text = "\(priceText) \(bargainPriceText)"
        }
    }
    
    private func attributedString(priceTextLength: Int, bargainPriceTextLength: Int) {
        guard let text: String = text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                                        .foregroundColor: UIColor.red],
                                       range: NSRange(location: 0,
                                                      length: priceTextLength))
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.gray,
                                      range: NSRange(location: priceTextLength,
                                                     length: text.count - priceTextLength))
        attributedText = attributedString
    }
}
