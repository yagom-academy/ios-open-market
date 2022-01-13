//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/07.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet private var productImageView: UIImageView!
    @IBOutlet private var productNameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var discountPriceLabel: UILabel!
    @IBOutlet private var stockLabel: UILabel!

    static let listIdentifier = "ListView"
    static let gridIdentifier = "GridView"
    static let listNibName = "ListCollectionViewCell"
    static let gridNibName = "GridCollectionViewCell"
    
    private var priceLabels: [UILabel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceLabels = [priceLabel, discountPriceLabel, stockLabel]
    }
    
    func configureProduct(of product: Product) {
        resetLabel()
        productNameLabel.text = product.name
        setUpImage(url: product.thumbnail)
        setUpPrice(product: product)
        setUpDiscountPrice(product: product)
        setUpStock(product: product)
    }
    
    func configureStyle(of identifier: String) {
        identifier == Self.listIdentifier ? setupListView() : setupGridView()
    }
    
    private func resetLabel() {
        priceLabels.forEach { label in
            label.attributedText = nil
            label.textColor = nil
            label.text = nil
        }
    }
    
    private func setUpPrice(product: Product) {
        let formatedPrice = "\(product.currency.rawValue) \(product.price.fomattedString)"
        if product.discountedPrice == .zero {
            priceLabel.textColor = .systemGray
            priceLabel.text = formatedPrice
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = formatedPrice.strikeThrough
        }
    }
    
    private func setUpDiscountPrice(product: Product) {
        if product.discountedPrice == .zero {
            discountPriceLabel.isHidden = true
        } else {
            discountPriceLabel.isHidden = false
            discountPriceLabel.textColor = .systemGray
            discountPriceLabel.text = "\(product.currency.rawValue) \(product.bargainPrice.fomattedString)"
        }
    }
    
    private func setUpStock(product: Product) {
        if product.stock == .zero {
            stockLabel.textColor = .systemOrange
            stockLabel.text = "품절"
        } else {
            stockLabel.textColor = .systemGray
            stockLabel.text = "잔여수량 : \(product.stock)"
        }
    }

    private func setUpImage(url: String) {
        if let cachedImage = ImageManager.shared.loadCachedData(for: url) {
            productImageView.image = cachedImage
        } else {
            ImageManager.shared.downloadImage(with: url) { image in
                ImageManager.shared.setCacheData(of: image, for: url)
                self.productImageView.image = image
            }
        }
    }
    
    private func setupGridView() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
    }

    private func setupListView() {
        self.layer.cornerRadius = .zero
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = .zero
    }
    
}
