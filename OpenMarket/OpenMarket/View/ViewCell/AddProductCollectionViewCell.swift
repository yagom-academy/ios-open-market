//
//  AddProductViewCell.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/27.
//

import UIKit

final class AddProductCollectionViewCell: UICollectionViewCell {
    static let id = "ProductCell"

    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private func arrangeSubView() {
        self.contentView.addSubview(productImage)

        NSLayoutConstraint.activate([
            productImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            productImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            productImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            productImage.topAnchor.constraint(equalTo: self.contentView.topAnchor),
        ])
    }

    func configureCell(image: UIImage) {
        productImage.image = image
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeSubView()
    }
}
