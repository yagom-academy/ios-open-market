//
//  ListVCCell.swift
//  OpenMarket
//
//  Created by 기원우 on 2021/05/19.
//

import UIKit

class ListVCCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    var item: Item?
    
    func setup() {
//        thumbnail.image = UIImage(named: item.thumbnails[0])
        title.text = "loading..."
        price.text = ""
        discountedPrice.text = ""
        stock.text = ""
    }
    
    func setupItem() {
        if let data: Item = self.item {
            title.text = data.title
            price.text = "\(data.price)"
            if let salePrice = data.discountedPrice {
                discountedPrice.text = "\(salePrice)"
            }
            stock.text = "\(data.stock)"
        } else {
            print("item이 없는뎁쇼")
        }
        
    }
    
    
}
