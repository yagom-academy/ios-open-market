//
//  ImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/20.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configure() {
        imageView = UIImageView()
        self.addSubview(imageView)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        imageView.backgroundColor = .blue
    }
}
