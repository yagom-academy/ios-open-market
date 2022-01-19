//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/18.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var bargainPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
