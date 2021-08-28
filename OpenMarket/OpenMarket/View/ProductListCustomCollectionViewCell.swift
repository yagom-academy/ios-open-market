//
//  ProductListCustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kim Do hyung on 2021/08/24.
//

import UIKit

class ProductListCustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    
    static let identifier = "ProductListCustomCollectionViewCell"
    
    override func layoutSubviews() {
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        discountedPriceLabel.text = nil
        stockLabel.text = nil
    }
    
    func loadThumbnails(product: Product, completion: @escaping (UIImage?) -> Void ) {
        if let thumbnail = product.thumbnails.first,
           let thumbnailURL = URL(string: thumbnail) {
            URLSession.shared.dataTask(with: thumbnailURL) { (data, response, error) in
                if let _ = error {
                    completion( nil )
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
    }
    
    func updateLabels(title: UILabel, price: UILabel, discountdPrice: UILabel, stock: UILabel) {
        titleLabel = title
        priceLabel = price
        discountedPriceLabel = discountdPrice
        stockLabel = stock
    }
}

extension UICollectionViewCell {
    static func nib() -> UINib {
        return UINib(nibName: ProductListCustomCollectionViewCell.identifier, bundle: nil)
    }
}
