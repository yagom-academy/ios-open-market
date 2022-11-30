//
//  ProductItemCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

// MARK: ProductItemCellContent Protocol
protocol ProductItemCellContent {
    var task: URLSessionDataTask? { get }
    
    var thumbnailImageView: UIImageView { get set }
    var titleLabel: UILabel { get set }
    var subTitleLabel: UILabel { get set }
    var stockLabel: UILabel { get set }
    
    func configureLayout()
    func setupConstraints()
    func configureStyle()
}

// MARK: Configure Item Data
extension ProductItemCellContent {
    func setStockLabelValue(stock: Int) {
        if stock <= 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "잔여수량 : \(stock)"
            stockLabel.textColor = .secondaryLabel
        }
    }
    
    func setPriceLabel(originPrice: String, bargainPrice: String, segment: Int) {
        let bargainPriceString = (segment == 0 ? " \(bargainPrice)" : "\n\(bargainPrice)")
        
        if bargainPrice != originPrice {
            let text = originPrice + bargainPriceString
            subTitleLabel.attributedText = text.convertCancelLineString(target: originPrice)
        } else {
            subTitleLabel.text = originPrice
        }
    }
}

// MARK: String +
private extension String {
    func convertCancelLineString(target: String) -> NSMutableAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        let range = (self as NSString).range(of: target)
        let attributeString = NSMutableAttributedString(string: self)
        
        attributeString.addAttribute(.strikethroughColor, value: UIColor.red, range: range)
        attributeString.addAttribute(.strikethroughStyle, value: 1, range: range)
        attributeString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        attributeString.addAttribute(.font, value: font, range: range)
        
        return attributeString
    }
}
