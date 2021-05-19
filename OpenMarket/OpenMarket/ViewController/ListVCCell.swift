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
    
    func setup() {
//        thumbnail.image = UIImage(named: "loading.jpeg")
        title.text = "loading..."
        price.text = ""
        discountedPrice.text = ""
        stock.text = ""
    }
    
    
}
