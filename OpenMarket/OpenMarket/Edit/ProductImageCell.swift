//
//  ProductImageCell.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

final class ProductImageCell: UICollectionViewCell {
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
            
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(productImageView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
