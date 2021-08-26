//
//  MainCell.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/26.
//

import UIKit

class MainCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var remainedStockLabel: UILabel!
    
    func configure(with item: Goods) {
        titleLabel.text = item.title
        originalPriceLabel.text = item.price.description
        discountedPriceLabel.text = item.discountedPrice?.description ?? ""
        remainedStockLabel.text = item.stock.description
    }
}
