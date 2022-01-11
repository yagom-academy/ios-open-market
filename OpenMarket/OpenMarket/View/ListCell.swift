//
//  ListCell.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/11.
//

import UIKit

final class ListCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(product: Product) {
        guard let url = URL(string: product.thumbnailURL) else {
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            return
        }
        
        imageView.image = UIImage(data: data)
        productNameLabel.text = product.name
        discountedPriceLabel.text = product.discountedPrice.stringFormat
        priceLabel.text = product.price.stringFormat
        stockLabel.text = product.stock.stringFormat
    }
}
