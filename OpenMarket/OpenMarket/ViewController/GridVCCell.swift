//
//  GridVCCell.swift
//  OpenMarket
//
//  Created by ysp on 2021/05/27.
//

import UIKit

class GridVCCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    var item: Item?
    
    func setup() {
        title.text = "loading..."
        price.text = ""
        discountedPrice.attributedText = NSAttributedString(string: "")
        stock.text = ""
    }
    
    func setupItem() {
        if let data: Item = self.item {
            thumbnail.downloadImage(from: data.thumbnails[0])
            title.text = data.title
            price.text = "\(data.price)"
            if let salePrice = data.discountedPrice {
                discountedPrice.text = "\(salePrice)"
                discountedPrice.attributedText = discountedPrice.text?.strikeThrough()
                discountedPrice.textColor = UIColor.red
            }
            stock.text = "잔여수량 : " + "\(data.stock)"
        } else {
            print("no item")
        }
    }
    
}

