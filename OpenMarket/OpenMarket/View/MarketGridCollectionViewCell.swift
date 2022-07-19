//
//  MarketGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/19.
//

import UIKit

class MarketGridCollectionViewCell: UICollectionViewCell {
 
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemRed
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func arrangeSubView() {
        verticalStackView.addArrangedSubview(imageView)
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
        verticalStackView.addArrangedSubview(stockLabel)
        
        self.addSubview(verticalStackView)
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray3.cgColor
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        stockLabel.textColor = .systemGray
        priceLabel.textColor = .systemRed
    }
}
