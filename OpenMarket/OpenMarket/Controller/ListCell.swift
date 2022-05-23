//
//  ListCell.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/18.
//

import UIKit

final class ListCell: UICollectionViewCell, ItemCellable {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bargainPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!

    func configureCell(components: CellComponents) {
        itemNameLabel.text = components.name
        priceLabel.attributedText = components.price
        priceLabel.isHidden = !(components.isDiscounted)
        bargainPriceLabel.text = components.bargainPrice
        stockLabel.text = components.stock
        stockLabel.textColor = components.stockLabelColor
    }
    
    func configureImage(image: UIImage) {
        itemImageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemNameLabel.text = nil
        priceLabel.text = nil
        bargainPriceLabel.text = nil
        stockLabel.text = nil
        stockLabel.textColor = nil
    }
}
