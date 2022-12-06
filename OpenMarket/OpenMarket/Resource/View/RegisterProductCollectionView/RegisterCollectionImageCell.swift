//
//  RegisterCollectionImageCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class RegisterCollectionImageCell: UICollectionViewCell {
    static let identifier = String(describing: RegisterCollectionImageCell.self)
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    func imageViewConstraint() {
        
        contentView.addSubview(itemImageView)
        
        NSLayoutConstraint.activate([
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor)
        ])
    }
    
    func configureButtonStyle() {
        backgroundColor = .systemGroupedBackground
        itemImageView.image = UIImage(systemName: "plus.circle.fill")
        itemImageView.tintColor = .blue
        imageViewConstraint()
    }
}
