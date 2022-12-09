//
//  DetailProductCollectionViewCell.swift
//  OpenMarket
//
//  Created by parkhyo on 2022/12/09.
//

import UIKit

final class DetailProductCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func uploadImage(_ image: UIImage) {
        productImageView.image = image
    }
}

// MARK: - Constraints
extension DetailProductCollectionViewCell {
    private func setupUI() {
        contentView.addSubview(productImageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension DetailProductCollectionViewCell: ReuseIdentifierProtocol {
    
}
