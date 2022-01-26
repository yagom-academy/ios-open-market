//
//  ImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/20.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configure() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}
