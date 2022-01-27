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
    @IBOutlet private var indicator: UIButton!

    static let listIdentifier = "ListView"
    static let gridIdentifier = "GridView"
    static let listNibName = "ListCollectionViewCell"
    static let gridNibName = "GridCollectionViewCell"
    
    private var priceLabels: [UILabel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpAccessibility()
        setUpSelectedView()
        resetLabel()
        productImageView.image = nil
        priceLabels = [priceLabel, discountPriceLabel, stockLabel]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetLabel()
        productImageView.image = nil
    }
    
    func setUpSelectedView() {
        selectedBackgroundView = UIView(frame: self.bounds)
        selectedBackgroundView?.backgroundColor = .systemGray5
    }
    
    private func setUpAccessibility() {
        productNameLabel.adjustsFontForContentSizeCategory = true
        priceLabel.adjustsFontForContentSizeCategory = true
        discountPriceLabel.adjustsFontForContentSizeCategory = true
        stockLabel.adjustsFontForContentSizeCategory = true
    }
    
    func configureProduct(of product: Product) {
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
        let formattedPrice = "\(product.currency.rawValue) \(product.price.fomattedString)"
        if product.discountedPrice == .zero {
            priceLabel.textColor = .systemGray
            priceLabel.text = formattedPrice
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = formattedPrice.strikeThrough
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
