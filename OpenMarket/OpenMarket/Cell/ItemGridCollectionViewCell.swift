//
//  ItemGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 김지혜 on 2021/02/05.
//

import UIKit

class ItemGridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemStockLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDiscountedPriceLabel: UILabel!
    private var model: ItemViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemTitleLabel.text = nil
        itemStockLabel.text = nil
        itemPriceLabel.text = nil
        itemDiscountedPriceLabel.text = nil
    }
    
    func setModel(_ model: ItemViewModel) {
        self.model = model
        updateUI()
    }
    
    func updateUI() {
        guard let item = model else { return }
        item.getImage { [weak self] image in
            self?.itemImageView.image = image
        }
        itemTitleLabel.text = item.title
        itemStockLabel.text = item.stock
        itemStockLabel.textColor = item.stockColor
        
        if let discountedPrice = item.discountedPrice {
            itemPriceLabel.isHidden = false
            itemPriceLabel.attributedText = NSAttributedString(string: item.price, attributes: [.strikethroughStyle: 1])
            itemDiscountedPriceLabel.text = discountedPrice
        } else {
            itemPriceLabel.isHidden = true
            itemDiscountedPriceLabel.text = item.price
        }
    }
}
