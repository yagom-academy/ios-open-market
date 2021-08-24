//
//  OpenMarketItemCell.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/20.
//

import UIKit

class OpenMarketItemCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    private var imageDataTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDataTask?.cancel()
        imageDataTask = nil
    }
    
    func configure(from product: Product, with dataTask: URLSessionDataTask?) {
        resetContents()
        
        imageDataTask = dataTask
        titleLabel.text = product.title
        priceLabel.text = product.price.description
        stockLabel.text = product.stock.description
        if let discountedPrice = product.discountedPrice {
            discountedPriceLabel.text = discountedPrice.description
        }
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
    
    private func resetContents() {
        imageView.image = #imageLiteral(resourceName: "WaitingImage")
        titleLabel.text = nil
        priceLabel.text = nil
        stockLabel.text = nil
        discountedPriceLabel.text = nil
    }

}
