//
//  GridCell.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/18.
//

import UIKit

final class GridCell: UICollectionViewCell, ItemCellable {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bargainPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
        
    func configureCell(items: [Item], indexPath: IndexPath) {
        itemNameLabel.text = items[indexPath.row].name
        priceLabel.attributedText = (items[indexPath.row].currency + items[indexPath.row].price.description).strikethrough()
        
        if items[indexPath.row].discountedPrice == 0 {
                priceLabel.isHidden = true
            } else {
                priceLabel.isHidden = false
        }
        
        bargainPriceLabel.text = items[indexPath.row].currency + items[indexPath.row].bargainPrice.description
        
        if items[indexPath.row].stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        } else {
            stockLabel.text = "잔여수량 : \(items[indexPath.row].stock)"
            stockLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
    }
    
    func configureImage(image: UIImage) {
        itemImageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemNameLabel.text = nil
        priceLabel.text = nil
        bargainPriceLabel.text = nil
        stockLabel.text = nil
        stockLabel.textColor = nil
    }
}
