//
//  UICollectionViewCell + extension.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/22.
//

import UIKit

extension UICollectionViewCell {
    func showPrice(priceLabel: UILabel, bargainPriceLabel: UILabel, product: SaleInformation) {
        priceLabel.text = "\(product.currency) \(product.price)"
        if product.bargainPrice == 0.0 {
            priceLabel.textColor = .systemGray
            bargainPriceLabel.isHidden = true
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            bargainPriceLabel.text = "\(product.currency) \(product.price)"
            bargainPriceLabel.textColor = .systemGray
        }
    }
    
    func showSoldOut(productStockQuntity: UILabel, product: SaleInformation) {
        if product.stock == 0 {
            productStockQuntity.text = "품절"
            productStockQuntity.textColor = .systemOrange
        } else {
            productStockQuntity.text = "잔여수량 : \(product.stock)"
            productStockQuntity.textColor = .systemGray
        }
    }
}
