//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/25.
//

import UIKit


@available(iOS 14.0, *)
class ListCollectionViewCell: UICollectionViewListCell {
    
    static let identifier = "ListCollectionViewCell"
    var representedIdentifier: IndexPath?
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var numberOfItemStock: UILabel!
    @IBOutlet var discountedPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initCellProperty()
    }
    
    override func prepareForReuse() {
        initCellProperty()
    }
    
    func initCellProperty() {
        self.itemImage.image = UIImage(named: "indicator")
        self.itemPrice.attributedText = self.itemPrice.text?.removeStrikeThrough()
        self.itemTitle.text = nil
        self.numberOfItemStock.text = nil
        self.itemPrice.text = nil
        self.discountedPrice.isHidden = true
        self.itemPrice.attributedText = NSAttributedString(string: "")
        self.itemPrice.textColor = UIColor.lightGray
        NSLayoutConstraint.activate([separatorLayoutGuide.leadingAnchor.constraint(equalTo: itemImage.leadingAnchor)])
    }
    
    func configure(with data: Item, itemIndexPath: Int) {
        self.itemTitle.text = data.title
        self.numberOfItemStock.text = "잔여수량 : " + String(data.stock)
        if let discountedPrice = data.discountedPrice {
            self.discountedPrice.isHidden = false
            self.discountedPrice.text = data.currency + " " + String(discountedPrice)
            self.itemPrice.textColor = UIColor.red
            self.itemPrice.text = data.currency + " " + String(data.price)
            self.itemPrice.attributedText = self.itemPrice.text?.strikeThrough()
        } else {
            self.itemPrice.text = data.currency + " " + String(data.price)
        }
        guard Cache.shared.thumbnailImageDataList.count > itemIndexPath else { return }
        let thumbnailImage = Cache.shared.thumbnailImageDataList[itemIndexPath]
        self.itemImage.image = UIImage(data: thumbnailImage)
    }
    
    
}
