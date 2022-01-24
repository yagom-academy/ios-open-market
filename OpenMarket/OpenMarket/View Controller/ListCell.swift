//
//  ListCell.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/20.
//

import UIKit

class ListCell: UICollectionViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLable: UILabel!
    @IBOutlet private weak var priceLable: UILabel!
    @IBOutlet private weak var discountedPriceLable: UILabel!
    @IBOutlet private weak var stockLable: UILabel!

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
                self.thumbnailImageView.image = UIImage(data: imageData ?? Data())
            }
        }
        
        let commaPrice = "\(productData.price)".insertCommaInThousands()
        let commaDiscountedPrice = "\(productData.discountedPrice)".insertCommaInThousands()
        nameLable.text = productData.name
        priceLable.text = "\(productData.currency) \(commaPrice)  "
        discountedPriceLable.text = "\(productData.currency) \(commaDiscountedPrice)"
        discountedPriceLable.textColor = .systemGray

        if productData.stock == 0 {
            stockLable.text = "품절"
            stockLable.textColor = .systemYellow
        } else {
            stockLable.text = "잔여수량: \(productData.stock)"
            stockLable.textColor = .systemGray
        }
    }
}
