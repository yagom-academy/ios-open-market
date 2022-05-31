//
//  DetailCollectionViewCell.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/31.
//

import UIKit

final class DetailCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let pageLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(pageLabel)
        
        setupLayoutConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayoutConstraint() {
        
        imageView.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: mainStackView.centerYAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: mainStackView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        
        
        imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95).isActive = true

        
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        

    }
}
