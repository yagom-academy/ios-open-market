//
//  ProductInfoStackView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/24.
//

import UIKit

class ProductInfoStackView: UIStackView {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bargainPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpSpacing()
    }

    func configureProductInfo(product: Product) {
        setUpName(product: product)
        setUpPrice(product: product)
        setUpDiscountPrice(product: product)
        setUpStock(product: product)
        descriptionLabel.text = product.description
    }
    
    func setUpName(product: Product) {
        nameLabel.font = .preferredFont(for: .title1, weight: .bold)
        nameLabel.text = product.name
    }
    
    private func setUpPrice(product: Product) {
        let formatedPrice = "\(product.currency.rawValue) \(product.price.fomattedString)"
        if product.bargainPrice == .zero {
            priceLabel.textColor = .systemGray
            priceLabel.text = formatedPrice
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = formatedPrice.strikeThrough
        }
        priceLabel.font = .preferredFont(for: .title3, weight: .bold)
    }
    
    private func setUpDiscountPrice(product: Product) {
        if product.bargainPrice == .zero {
            bargainPriceLabel.isHidden = true
        } else {
            bargainPriceLabel.isHidden = false
            bargainPriceLabel.textColor = .black
            bargainPriceLabel.text = "\(product.currency.rawValue) \(product.bargainPrice.fomattedString)"
        }
        bargainPriceLabel.font = .preferredFont(for: .title3, weight: .bold)
    }
    
    private func setUpStock(product: Product) {
        if product.stock == .zero {
            stockLabel.textColor = .systemOrange
            stockLabel.text = "품절"
        } else {
            stockLabel.textColor = .systemGray
            stockLabel.text = "남은 수량 : \(product.stock)"
        }
    }
    
    private func setUpSpacing() {
        self.setCustomSpacing(20, after: priceStackView)
    }
}
