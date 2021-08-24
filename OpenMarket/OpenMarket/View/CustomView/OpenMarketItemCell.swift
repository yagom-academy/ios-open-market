//
//  OpenMarketItemCell.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/20.
//

import UIKit

class OpenMarketItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    private var imageDataTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    private func resetContents() {
        titleLabel.text = nil
        priceLabel.text = nil
        stockLabel.text = nil
        discountedPriceLabel.text = nil
    }

}
