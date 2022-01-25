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
    @IBOutlet private weak var priceLable: UILabel!
    @IBOutlet private weak var discountedPriceLable: UILabel!
    @IBOutlet private weak var stockLable: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray2.cgColor
    }
    
    func updateGridCell(productData: ProductPreview) {
        guard let imageURL = URL(string: "\(productData.thumbnail)") else {
            return
        }
        loadImage(url: imageURL) { image in
            DispatchQueue.main.async {
                self.thumbnailImageView.image = image
            }
        }
        
        let commaPrice = "\(productData.price)".insertCommaInThousands()
        let commaDiscountedPrice = "\(productData.discountedPrice)".insertCommaInThousands()
        nameLable.text = productData.name
        priceLable.text = "\(productData.currency) \(commaPrice) "
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
    
    func loadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }
        task.resume()
    }
}
