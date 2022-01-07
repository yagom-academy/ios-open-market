//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/07.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var backgroundStackView: UIStackView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var priceStackView: UIStackView!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productDiscountPrice: UILabel!
    @IBOutlet var productStockPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 1
    }

}
