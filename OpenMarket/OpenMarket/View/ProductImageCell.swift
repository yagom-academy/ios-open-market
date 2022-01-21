//
//  ProductImageCell.swift
//  OpenMarket
//
//  Created by 이승재 on 2022/01/19.
//

import UIKit

class ProductImageCell: UICollectionViewCell {

    private let imageView = UIImageView()

    private lazy var addLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var capacityLabel: UILabel = {
        let label = UILabel()
        label.text = "0 / 5"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    func configureFirstCell() {
        self.addSubview(addLabel)
        self.addSubview(capacityLabel)
        NSLayoutConstraint.activate([
            addLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            addLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            capacityLabel.centerXAnchor.constraint(equalTo: addLabel.centerXAnchor),
            capacityLabel.topAnchor.constraint(equalTo: addLabel.bottomAnchor, constant: 10)
        ])
    }

    func modifyCapacityLabel(for number: Int) {
        self.capacityLabel.text = "\(number) / 5"
    }
}
