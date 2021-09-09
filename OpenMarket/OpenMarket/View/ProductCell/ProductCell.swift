//
//  ProductCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/04.
//

import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    private let imageManager = ImageManager()
    private var imageDataTask: URLSessionTask?
    private static let maximumStockAmount = 999
    static let listIdentifier = "ProductListCell"
    static let gridItentifier = "ProductGridCell"
    static let listNibName = "ProductListCell"
    static let gridNibName = "ProductGridCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpTextWidth()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
        imageDataTask?.cancel()
    }
    
    private func setUpTextWidth() {
        titleLabel.adjustsFontSizeToFitWidth = true
        priceLabel.adjustsFontSizeToFitWidth = true
        discountedPriceLabel.adjustsFontSizeToFitWidth = true
        stockLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func resetContents() {
        titleLabel.text = nil
        priceLabel.attributedText = nil
        priceLabel.text = nil
        priceLabel.textColor = nil
        discountedPriceLabel.text = nil
        stockLabel.text = nil
        stockLabel.textColor = nil
    }
    
    func productConfigure(product: Product, identifier: String) {
        textConfigure(product: product)
        imageConfigure(product: product)
        styleConfigure(identifier: identifier)
    }
    
    private func textConfigure(product: Product) {
        resetContents()
        self.titleLabel.text = product.title
        
        if let discountedPrice = product.discountedPrice {
            priceLabel.attributedText =
                "\(product.currency) \(product.price.withComma)".strikeThrough
            priceLabel.textColor = .systemRed
            discountedPriceLabel.text = "\(product.currency) \(discountedPrice.withComma)"
        } else {
            priceLabel.text = "\(product.currency) \(product.price.withComma)"
            priceLabel.textColor = .systemGray
        }
        
        if product.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        } else if product.stock > Self.maximumStockAmount {
            stockLabel.text = "잔여수량 : \(Self.maximumStockAmount) +"
            stockLabel.textColor = .systemGray
        } else {
            stockLabel.text = "잔여수량 : \(product.stock)"
            stockLabel.textColor = .systemGray
        }
    }
    
    private func styleConfigure(identifier: String) {
        if identifier == Self.gridItentifier {
            self.layer.cornerRadius = 10
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    private func imageConfigure(product: Product) {
        if let successImage = product.thumbnails.first {
            imageDataTask = imageManager.fetchImage(url: successImage) { image in
                DispatchQueue.main.async {
                    switch image {
                    case .success(let image):
                        self.thumbnailImage.image = image
                    case .failure:
                        self.thumbnailImage.image = #imageLiteral(resourceName: "LoadedImageFailed")
                    }
                }
            }
        }
    }
}
