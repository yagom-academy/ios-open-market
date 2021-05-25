//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/25.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
