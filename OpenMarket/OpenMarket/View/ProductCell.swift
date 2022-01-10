//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/07.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var discountPriceLabel: UILabel!
    @IBOutlet var stockLabel: UILabel!

    static let listIdentifier = "ListView"
    static let gridItentifier = "GridView"
    static let listNibName = "ListCollectionViewCell"
    static let gridNibName = "GridCollectionViewCell"
    
    var priceLabels: [UILabel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        priceLabels = [priceLabel, discountPriceLabel, stockLabel]
    }
    
    func productConfigure(product: Product) {
        productImageView.image = UIImage(data: imageData(url: product.thumbnail))
        productNameLabel.text = product.name
        resetLabel()
        priceConfigure(product: product)
        discountPriceConfigure(product: product)
        stockConfigure(product: product)
    }
    
    private func resetLabel() {
        priceLabels.forEach { label in
            label.attributedText = nil
            label.textColor = nil
            label.text = nil
        }
    }
    
    private func priceConfigure(product: Product) {
        let formatedPrice = "\(product.currency.rawValue) \(product.price.fomattingString)"
        if product.discountedPrice == 0 {
            priceLabel.textColor = .systemGray
            priceLabel.text = formatedPrice
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = formatedPrice.strikeThrough
        }
    }
    
    private func discountPriceConfigure(product: Product) {
        if product.discountedPrice == 0 {
            discountPriceLabel.isHidden = true
        } else {
            discountPriceLabel.isHidden = false
            discountPriceLabel.textColor = .systemGray
            discountPriceLabel.text = "\(product.currency.rawValue) \(product.bargainPrice.fomattingString)"
        }
    }
    
    private func stockConfigure(product: Product) {
        if product.stock == 0 {
            stockLabel.textColor = .systemOrange
            stockLabel.text = "품절"
        } else {
            stockLabel.textColor = .systemGray
            stockLabel.text = "잔여수량 : \(product.stock)"
        }
    }

    func styleConfigure(identifier: String) {
        if identifier == Self.listIdentifier {
            setupListView()
        } else {
            setupGridView()
        }
    }
    
    private func imageData(url: String) -> Data {
        guard let url = URL(string: url), let data = try? Data(contentsOf: url) else {
            return Data()
        }
        return data
    }
    
    private func setupGridView() {
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
    }

    private func setupListView() {
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
}
