//
//  ListCell.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/18.
//

import UIKit

final class ListCell: UICollectionViewCell, ItemCellable {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bargainPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    
    var itemImage: UIImage? = UIImage(){
        didSet {
            self.itemImageView.image = itemImage
        }
    }
    
    var itemName: String = "" {
        didSet {
            self.itemNameLabel.text = itemName
        }
    }
    
    var price: String = "" {
        didSet {
            self.priceLabel.text = price
        }
    }
    
    var isDiscount: Bool = true {
        didSet {
            if isDiscount {
                self.priceLabel.isHidden = false
            } else {
                self.priceLabel.isHidden = true
            }
        }
    }
    
    var bargainPrice: String = "" {
        didSet {
            self.bargainPriceLabel.text = bargainPrice
        }
    }
    
    var stock: String = "" {
        didSet {
            self.stockLabel.text = stock
        }
    }
}
