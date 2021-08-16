//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by YongHoon JJo on 2021/08/16.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemThumbnailImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDiscountedPriceLabel: UILabel!
    @IBOutlet weak var itemStockLabel: UILabel!
}
