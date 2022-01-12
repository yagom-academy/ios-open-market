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
        let imageResult = imageData(url: product.thumbnail)
        
        switch imageResult {
        case .success(let data):
            productImageView.image = UIImage(data: data)
        case .failure(let error):
            print(error.localizedDescription)
        }
        productNameLabel.text = product.name
        resetLabel()
        priceConfigure(product: product)
        discountPriceConfigure(product: product)
        stockConfigure(product: product)
    }
    
    func configureStyle(of identifier: String) {
        if identifier == Self.listIdentifier {
            setupListView()
        } else {
            setupGridView()
        }
    }
    
    private func resetLabel() {
        priceLabels.forEach { label in
            label.attributedText = nil
            label.textColor = nil
            label.text = nil
        }
    }
    
    private func priceConfigure(product: Product) {
        let formatedPrice = "\(product.currency.rawValue) \(product.price.fomattedString)"
        if product.discountedPrice == .zero {
            priceLabel.textColor = .systemGray
            priceLabel.text = formatedPrice
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = formatedPrice.strikeThrough
        }
    }
    
    private func discountPriceConfigure(product: Product) {
        if product.discountedPrice == .zero {
            discountPriceLabel.isHidden = true
        } else {
            discountPriceLabel.isHidden = false
            discountPriceLabel.textColor = .systemGray
            discountPriceLabel.text = "\(product.currency.rawValue) \(product.bargainPrice.fomattedString)"
        }
    }
    
    private func stockConfigure(product: Product) {
        if product.stock == .zero {
            stockLabel.textColor = .systemOrange
            stockLabel.text = "품절"
        } else {
            stockLabel.textColor = .systemGray
            stockLabel.text = "잔여수량 : \(product.stock)"
        }
    }

    private func imageData(url: String) -> Result<Data, Error> {
        guard let url = URL(string: url), let data = try? Data(contentsOf: url) else {
            return .failure(OpenMarketError.badRequestURL)
        }
        return .success(data)
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
