//
//  CustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by 서현웅 on 2022/11/22.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bargainPrice: UILabel!
    @IBOutlet weak var stock: UILabel!
    
    func configureCell(imageSource: String,
                       name: String,
                       currency: Currency,
                       price: Double,
                       bargainPrice: Double,
                       stock: Int
    ) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let imageUrl = URL(string: imageSource),
              let imageData = try? Data(contentsOf: imageUrl),
              let price = numberFormatter.string(for: price),
              let bargainPrice = numberFormatter.string(for: bargainPrice),
              let nextImage = UIImage(systemName: "chevron.right") else { return }
        
        self.thumbnail.image = UIImage(data: imageData)
        self.name.text = name
        self.price.text = "\(currency) \(price)"
        self.bargainPrice.text = "\(currency) \(bargainPrice)"
        if stock > 0 {
            self.stock.text = "잔여수량 : \(stock) \(nextImage)"
        } else {
            self.stock.text = "품절 \(nextImage)"
            self.stock.textColor = UIColor.systemYellow
        }
    }
}
