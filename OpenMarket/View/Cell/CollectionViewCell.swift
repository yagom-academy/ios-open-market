//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/25.
//

import UIKit

@available(iOS 14.0, *)
class CollectionViewCell: UICollectionViewListCell {
    
    static let identifier = "CollectionViewCell"
    var representedIdentifier: String = ""
    
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
        self.itemImage.image = nil
        self.itemPrice.attributedText = self.itemPrice.text?.removeStrikeThrough()
        self.itemTitle.text = nil
        self.numberOfItemStock.text = nil
        self.itemPrice.text = nil
        self.discountedPrice.isHidden = true
        self.itemPrice.attributedText = NSAttributedString(string: "")
        self.itemPrice.textColor = UIColor.lightGray
    }
    
    
    func configure(with viewModel: CellViewModel) {
        let imageURL = URL(string: viewModel.item.thumbnails[0])
        do {
            let imageData = try Data(contentsOf: imageURL!)
            
            self.itemImage.image = UIImage(data: imageData)
            self.itemTitle.text = viewModel.item.title
            self.numberOfItemStock.text = "잔여수량 : " + String(viewModel.item.stock)
            if let discountedPrice = viewModel.item.discountedPrice {
                self.discountedPrice.isHidden = false
                self.discountedPrice.text = viewModel.item.currency + " " + String(discountedPrice)
                self.itemPrice.textColor = UIColor.red
                self.itemPrice.text = viewModel.item.currency + " " + String(viewModel.item.price)
                self.itemPrice.attributedText = self.itemPrice.text?.strikeThrough()
            } else {
                self.itemPrice.text = viewModel.item.currency + " " + String(viewModel.item.price)
            }
            
        } catch {
            print("Invalid URL")
        }
    }
    
    
}
