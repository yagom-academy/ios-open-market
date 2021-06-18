//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by Sunny on 2021/06/14.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemThumbnail: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemQuantity: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemDiscounted: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
