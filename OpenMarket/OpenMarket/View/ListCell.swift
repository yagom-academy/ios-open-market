//
//  ListCell.swift
//  OpenMarket
//
//  Created by 권나영 on 2022/01/11.
//

import UIKit

@available(iOS 14.0, *)
class ListCell: UICollectionViewListCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessories = [.disclosureIndicator()]
    }
    
}
