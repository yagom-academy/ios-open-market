//
//  PhotoCollectionViewCell.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/20.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "PhotoCollectionViewCell"

    var image: UIImage? {
        didSet {
            guard let image = image else {
                return
            }
            imageView.image = image
        }
    }

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        contentView.backgroundColor = .systemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageView.frame = CGRect(x: 0,
//                                 y: 0,
//                                 width: contentView.frame.size.width,
//                                 height: contentView.frame.size.height)
//    }
}
