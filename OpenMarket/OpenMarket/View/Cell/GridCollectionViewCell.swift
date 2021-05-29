//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/05/27.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell, OpenMarketCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        priceLabel.attributedText = nil
        priceLabel.textColor = .black
        stockLabel.textColor = .black
        discountedPriceLabel.isHidden = false
    }
}
