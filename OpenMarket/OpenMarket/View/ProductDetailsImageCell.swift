//
//  ProductDetailsImageCell.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/27.
//

import UIKit

final class ProductDetailsImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with imageURL: String) {
        setImageView(with: imageURL)
    }
    
    private func setImageView(with urlString: String) {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url) else {
            return
        }
        imageView.image = UIImage(data: data)
    }
}

extension ProductDetailsImageCell: IdentifiableView {}
