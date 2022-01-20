//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/19.
//

import UIKit

class GridCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    func updateGridCell(productData: ProductPreview) {
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
        stock.text = "잔여수량: \(productData.stock)"
        price.text = "\(productData.currency) \(productData.price)"
        discountedPrice.text = "\(productData.currency) \(productData.discountedPrice)"
    }
}
