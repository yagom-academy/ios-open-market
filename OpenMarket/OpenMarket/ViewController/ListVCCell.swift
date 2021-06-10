//
//  ListVCCell.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/19.
//

import UIKit

class ListVCCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    var item: Item?
    
    func setup() {
        titleLabel.text = "loading..."
        priceLabel.text = ""
        discountedPriceLabel.attributedText = NSAttributedString(string: "")
        stockLabel.text = ""
    }
    
    func setupItem() {
        if let data: Item = self.item {
            thumbnailImageView.downloadImage(from: data.thumbnails[0])
            titleLabel.text = data.title
            priceLabel.text = data.currency + " \(data.price)"
            priceLabel.textColor = UIColor.lightGray
            if let salePrice = data.discountedPrice {
                discountedPriceLabel.text = data.currency + " \(salePrice)"
                discountedPriceLabel.attributedText = discountedPriceLabel.text?.strikeThrough()
                discountedPriceLabel.textColor = UIColor.red
            }
            stockLabel.text = "\(data.stock)"
            stockLabel.textColor = UIColor.lightGray
        } else {
            print("no item")
        }
    }
}



