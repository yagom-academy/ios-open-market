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
    private var index: Int?
    private var model: ItemViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemTitleLabel.text = nil
        itemStockLabel.text = nil
        itemPriceLabel.text = nil
        itemDiscountedPriceLabel.text = nil
    }
    
    func setModel(index: Int, _ model: ItemViewModel) {
        self.index = index
        self.model = model
        updateUI()
    }
    
    func updateUI() {
        guard let item = model,
              let index = index else { return }
        
        if let thumbnail = item.thumbnail {
            NetworkLayer.shared.requestImage(urlString: thumbnail, index: index) { [weak self] image, index in
                guard index == self?.index else { return }
                self?.itemImageView.image = image
            }
        } else {
            itemImageView.image = UIImage(named: "image1")
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
