//
//  ItemGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/05.
//

import UIKit

class ItemGridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemStockLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDiscountedPriceLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemTitleLabel.text = nil
        itemStockLabel.text = nil
        itemPriceLabel.text = nil
        itemDiscountedPriceLabel.text = nil
    }
}
