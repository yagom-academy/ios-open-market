//
//  ImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/01.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let addImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray5
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}

// MARK: - Constraints
extension ImageCollectionViewCell {
    private func setupUI() {
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(addImageButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addImageButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setupAddImageConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

extension ImageCollectionViewCell: ReuseIdentifierProtocol {
    
}
