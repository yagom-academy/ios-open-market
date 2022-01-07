//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/07.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var backgroundStackView: UIStackView!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productStackView: UIStackView!
    @IBOutlet var productInfoStackView: UIStackView!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productStock: UILabel!
    @IBOutlet var priceStackView: UIStackView!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var productDiscountPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
