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
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price: UILabel!
     //init시점,-codable, loadView시점, 스냅킷?
    @IBOutlet weak var discountedPrice: UILabel!
    

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
        stock.text = "잔여수량: \(productData.stock)"
        price.text = "\(productData.currency) \(productData.price)"
        discountedPrice.text = "\(productData.currency) \(productData.discountedPrice)"
        
    }
    
}
