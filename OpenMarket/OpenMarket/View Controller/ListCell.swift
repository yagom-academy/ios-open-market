//
//  ListCell.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/20.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    @IBOutlet weak var stock: UILabel!

    override func awakeFromNib() {
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = .none
    }
    
    func updateListCell(productData: ProductPreview) {
        DispatchQueue.global().async {
            guard let imageURL = URL(string: "\(productData.thumbnail)") else {
                return
            }
            let imageData = try? Data(contentsOf: imageURL)
            
            DispatchQueue.main.async { 
                self.thumbnail.image = UIImage(data: imageData ?? Data())
            }
        }
        
        name.text = productData.name
        price.text = "\(productData.currency) \(productData.price) "
        price.sizeToFit()
        discountedPrice.text = "\(productData.currency) \(productData.discountedPrice)"
        
        if productData.stock == 0 {
            stock.text = "품절"
            stock.textColor = .systemYellow
        } else {
            stock.text = "잔여수량: \(productData.stock)"
        }
    }
    
}
