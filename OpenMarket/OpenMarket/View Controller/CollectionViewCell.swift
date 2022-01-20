//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/19.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountedPrice: UILabel!
    
    func updateCell(data: ProductList, indexPathItem: Int) {
        guard let imageURL = URL(string: "\(data.productsInPage[indexPathItem].thumbnail)") else {
            return
        }
        let imageData = try? Data(contentsOf: imageURL)
        
        thumbnail.image = UIImage(data: imageData ?? Data())
        name.text = data.productsInPage[indexPathItem].name
        stock.text = "\(data.productsInPage[indexPathItem].stock)"
        price.text = "\(data.productsInPage[indexPathItem].currency) \(data.productsInPage[indexPathItem].price)"
        discountedPrice.text = "\(data.productsInPage[indexPathItem].currency) \(data.productsInPage[indexPathItem].discountedPrice)"
   

        
    }
    
}
