//
//  ImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2/12/2022.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "imageCell"
    let imageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()
    
    func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
