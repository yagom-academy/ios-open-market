//
//  ProductCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/04.
//

import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    private let imageManager = ImageManager()
    private static let maximumStockAmount = 999
    static let listIdentifier = "ProductListCell"
    static let gridItentifier = "ProductGridCell"
    static let listNibName = "ProductListCell"
    static let gridNibName = "ProductGridCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        priceLabel.adjustsFontSizeToFitWidth = true
        discountedPriceLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true
    }
    
    func imageConfigure(product: Product) {
        if let successImage = product.thumbnails.first {
            imageManager.loadedImage(url: successImage) { image in
                DispatchQueue.main.async {
                    switch image {
                    case .success(let image):
                        self.imageView.image = image
                    case .failure:
                        self.imageView.image = #imageLiteral(resourceName: "LoadedImageFailed")
                    }
                }
            }
        }
    }
    
    func textConfigure(product: Product) {
        self.titleLabel.text = product.title
        
        if let discountedPrice = product.discountedPrice {
            priceLabel.attributedText = "\(product.currency) \(product.price.withComma)".strikeThrough
            priceLabel.textColor = .red
            discountedPriceLabel.text = "\(product.currency) \(discountedPrice.withComma)"
            discountedPriceLabel.textColor = .gray
        } else {
            priceLabel.text = "\(product.currency) \(product.price.withComma)"
            priceLabel.textColor = .gray
            discountedPriceLabel.text = nil
        }
        
        if product.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else if product.stock > Self.maximumStockAmount {
            stockLabel.text = "잔여수량 : \(Self.maximumStockAmount) +"
            stockLabel.textColor = .gray
        } else {
            stockLabel.text = "잔여수량 : \(product.stock)"
            stockLabel.textColor = .gray
        }
    }
    
    func styleConfigure(identifier: String) {
        if identifier == Self.gridItentifier {
            self.layer.cornerRadius = 10
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray.cgColor
        }
    }

    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
        priceLabel.attributedText = nil
        priceLabel.text = nil
        priceLabel.textColor = nil
        discountedPriceLabel.text = nil
        stockLabel.textColor = nil
        stockLabel.text = nil
    }
}
