//
//  RegistrationImageCell.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/12/05.
//

import UIKit

final class RegistrationImageCell: UICollectionViewCell {
    static let identifier = "cell"
    
    func addImage(_ image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func addDeleteButton(selector: Selector) {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(nil, action: selector, for: .touchUpInside)
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor,
                                            constant: contentView.bounds.width / 2),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor,
                                            constant: -contentView.bounds.width / 2),
            button.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                          multiplier: 0.2),
            button.heightAnchor.constraint(equalTo: contentView.widthAnchor,
                                          multiplier: 0.2)
        ])
    }
    
    func addButton(selector: Selector) {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: selector, for: .touchUpInside)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
}
