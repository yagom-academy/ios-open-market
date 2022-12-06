//
//  ImageTableViewCell.swift
//  OpenMarket
//
//  Created by 정선아 on 2022/12/06.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(productImageView)
        self.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 150),
            productImageView.widthAnchor.constraint(equalToConstant: 150),
            
            plusButton.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor),
            plusButton.topAnchor.constraint(equalTo: productImageView.topAnchor),
            plusButton.heightAnchor.constraint(equalTo: productImageView.heightAnchor),
            plusButton.widthAnchor.constraint(equalTo: productImageView.widthAnchor)
        ])
    }
}
