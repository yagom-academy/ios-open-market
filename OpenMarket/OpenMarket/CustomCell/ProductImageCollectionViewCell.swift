//
//  ProductImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by Siwon Kim on 2022/01/27.
//

import UIKit

class ProductImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    
    static let identifier = "ProductImageCell"
    
    func setupImage(with productImage: Image) {
        guard let imageURL = URL(string: productImage.url) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            let image = UIImage(data: data!)!
            DispatchQueue.main.async {
                self.productImageView.image = image
            }
        }.resume()
    }
}
