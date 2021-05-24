//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/17.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemPrice: UILabel!
    @IBOutlet var numberOfItemStock: UILabel!
    @IBOutlet var discountedPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.lightGray.cgColor
        initCellProperty()
    }
    
    override func prepareForReuse() {
        initCellProperty()
    }
    
    func initCellProperty() {
        self.itemImage.image = UIImage(named: "indicator")
        self.itemPrice.attributedText = self.itemPrice.text?.removeStrikeThrough()
        self.itemTitle.text = ""
        self.numberOfItemStock.text = ""
        self.itemPrice.text = ""
        self.discountedPrice.isHidden = true
        self.itemPrice.attributedText = NSAttributedString(string: "")
        self.itemPrice.textColor = UIColor.lightGray
    }
    
    func update(data: ItemsOfPageReponse, indexPath: IndexPath ,collectionView: UICollectionView) {
        let itemIndex = indexPath.row % 20
        let imageURL = URL(string: data.items[itemIndex].thumbnails[0])
        do {
            let imageData = try Data(contentsOf: imageURL!)
            
            DispatchQueue.main.async {
                print("@ \(indexPath), # \(collectionView.indexPath(for: self))")
                guard collectionView.indexPath(for: self) == indexPath else { return }
                
                self.itemImage.image = UIImage(data: imageData)
                self.itemTitle.text = data.items[itemIndex].title
                self.numberOfItemStock.text = "잔여수량 : " + String(data.items[itemIndex].stock)
                if let discountedPrice = data.items[itemIndex].discountedPrice {
                    self.discountedPrice.isHidden = false
                    self.discountedPrice.text = data.items[itemIndex].currency + " " + String(discountedPrice)
                    self.itemPrice.textColor = UIColor.red
                    self.itemPrice.text = data.items[itemIndex].currency + " " + String(data.items[itemIndex].price)
                    self.itemPrice.attributedText = self.itemPrice.text?.strikeThrough()
                } else {
                    self.itemPrice.text = data.items[itemIndex].currency + " " + String(data.items[itemIndex].price)
                }
            }
            
        } catch {
            print("Invalid URL")
        }
    }
}
