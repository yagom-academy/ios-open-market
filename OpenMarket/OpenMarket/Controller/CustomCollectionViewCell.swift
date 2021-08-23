//
//  CustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/08/23.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    
    func configure(item: ItemData) {
        item.image { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
