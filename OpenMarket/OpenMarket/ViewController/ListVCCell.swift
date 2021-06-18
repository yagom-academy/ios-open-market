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
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let data: Item = self.item {
            thumbnailImageView.downloadImage(from: data.thumbnails[0])
            titleLabel.text = data.title
            
            guard let dataPrice = numberFormatter.string(from: NSNumber(value: data.price)) else { return }
            priceLabel.text = data.currency + " \(dataPrice)"
            priceLabel.textColor = UIColor.lightGray
            
            
            discountedPriceLabel.textColor = UIColor.lightGray
            if let discountedPrice = data.discountedPrice {
                discountedPriceLabel.text = data.currency + " \(discountedPrice)"
                priceLabel.attributedText = priceLabel.text?.attributedStrikeThrough()
                priceLabel.textColor = UIColor.red
            }
            
            if data.stock == 0 {
                stockLabel.text = "품절"
                stockLabel.textColor = UIColor.orange
            } else {
                guard let datastock = numberFormatter.string(from: NSNumber(value: data.stock)) else { return }
                stockLabel.text = "잔여수량 : " + "\(datastock)"
                stockLabel.textColor = UIColor.lightGray
            }
        } else {
            print("no item")
        }
    }
}



