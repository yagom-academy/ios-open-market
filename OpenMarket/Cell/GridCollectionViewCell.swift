//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/23.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GridCollectionViewCell"
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
        self.itemTitle.text = ""
        self.numberOfItemStock.text = ""
        self.itemPrice.text = ""
        self.discountedPrice.isHidden = true
        self.itemPrice.attributedText = NSAttributedString(string: "")
        self.itemPrice.textColor = UIColor.lightGray
    }
    
    func update(data: ItemsOfPageReponse.Item) {
        let imageURL = URL(string: data.thumbnails[0])
        do {
            let imageData = try Data(contentsOf: imageURL!)
            
            self.itemImage.image = UIImage(data: imageData)
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
            
        } catch {
            print("Invalid URL")
        }
    }
    
    
    
}
