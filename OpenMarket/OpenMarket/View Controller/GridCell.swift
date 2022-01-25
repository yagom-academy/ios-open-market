//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 서녕 on 2022/01/19.
//

import UIKit

class GridCell: UICollectionViewCell {
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var nameLable: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    
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
                self.thumbnailImageView.image = UIImage(data: imageData ?? Data())
            }
        }
        
        let commaPrice = "\(productData.price)".insertCommaInThousands()
        let commaDiscountedPrice = "\(productData.discountedPrice)".insertCommaInThousands()
        nameLable.text = productData.name
        priceLabel.text = "\(productData.currency) \(commaPrice) "
        discountedPriceLabel.text = "\(productData.currency) \(commaDiscountedPrice)"
        discountedPriceLabel.textColor = .systemGray

        if productData.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "잔여수량: \(productData.stock)"
            stockLabel.textColor = .systemGray
        }
    }
}
