//
//  MarketListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/18.
//

import UIKit

class MarketListCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let accessaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "greaterthan")
        imageView.tintColor = .systemGray
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
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.textColor = .systemGray
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let subHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func arrangeSubView() {
        subHorizontalStackView.addArrangedSubview(stockLabel)
        subHorizontalStackView.addArrangedSubview(accessaryImageView)
        
        horizontalStackView.addArrangedSubview(nameLabel)
        horizontalStackView.addArrangedSubview(subHorizontalStackView)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(priceLabel)
        
        entireStackView.addArrangedSubview(imageView)
        entireStackView.addArrangedSubview(verticalStackView)
        
        self.addSubview(entireStackView)
        
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: self.topAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            entireStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.9),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        arrangeSubView()
        self.contentView.layer.addBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        stockLabel.textColor = .systemGray
        priceLabel.textColor = .systemRed
    }
}

extension CALayer {
    func addBottomBorder() {
        let border = CALayer()
        border.backgroundColor = UIColor.systemGray3.cgColor
        
        border.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5)
        
        self.addSublayer(border)
    }
}

