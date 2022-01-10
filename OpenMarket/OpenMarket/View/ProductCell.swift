//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/07.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet var backgroundStackView: UIStackView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var priceStackView: UIStackView!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productDiscountPrice: UILabel!
    @IBOutlet var productStockPrice: UILabel!

    static let listIdentifier = "ListView"
    static let gridItentifier = "GridView"
    static let listNibName = "ListCollectionViewCell"
    static let gridNibName = "GridCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func productConfigure(product: Product) {
        productImageView.image = UIImage(data: imageData(url: product.thumbnail))
        productNameLabel.text = product.name
        productPrice.text = "\(product.price)"
        productDiscountPrice.text = "\(product.discountedPrice)"
        productStockPrice.text = "\(product.stock)"
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
