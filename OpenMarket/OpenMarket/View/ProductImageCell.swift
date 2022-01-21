//
//  ProductImageCell.swift
//  OpenMarket
//
//  Created by 이승재 on 2022/01/19.
//

import UIKit

class ProductImageCell: UICollectionViewCell {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.backgroundColor = .systemGray4
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ProductImageCell {
    func configure(image: UIImage) {
        self.imageView.image = image
    }
}
