//
//  GridItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by 홍정아 on 2021/08/17.
//

import UIKit

class GridItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    func updateContents(item: Page.Item, indexPath: IndexPath, collectionView: UICollectionView) {
        self.titleLabel?.text = item.title
        self.priceLabel?.text = item.price.description
        self.stockLabel?.text = item.stock.description
        
        handleDiscountedPrice(item: item, indexPath: indexPath)
        
        ImageLoader.shared.loadImage(from: item.thumbnails[0],
                                     indexPath: indexPath,
                                     collectionView: collectionView,
                                     at: self)
    }
    
    func handleDiscountedPrice(item: Page.Item, indexPath: IndexPath) {
        if let discountedPrice = item.discountedPrice {
            discountedPriceLabel?.isHidden = false
            self.discountedPriceLabel?.text = discountedPrice.description
        } else {
            discountedPriceLabel?.isHidden = true
        }
    }
}
