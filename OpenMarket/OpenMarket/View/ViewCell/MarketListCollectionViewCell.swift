//
//  MarketListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/18.
//

import UIKit

final class MarketListCollectionViewCell: UICollectionViewCell {
    private let imageView: SessionImageView = {
        let imageView = SessionImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemRed
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()
    
    private let accessaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "greaterthan")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let subHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func configureCell(with item: Item, _ cell: UICollectionViewCell, _ indexPath: IndexPath, _ collectionView: UICollectionView) {
        self.nameLabel.text = item.productName
        
        if item.price == item.bargainPrice {
            self.priceLabel.text = item.price
            self.priceLabel.textColor = .systemGray
        } else {
            let price = item.price + " " + item.bargainPrice
            let attributeString = NSMutableAttributedString(string: price)
            
            attributeString.addAttribute(.strikethroughStyle,
                                         value: NSUnderlineStyle.single.rawValue,
                                         range: NSMakeRange(0, item.price.count))
            attributeString.addAttribute(.foregroundColor,
                                         value: UIColor.systemGray,
                                         range: NSMakeRange(item.price.count + 1, item.bargainPrice.count))
            self.priceLabel.attributedText = attributeString
        }
        
        if item.stock != "0" {
            self.stockLabel.text = "잔여수량 : " + item.stock
        } else {
            self.stockLabel.text = "품절"
            self.stockLabel.textColor = .systemOrange
        }
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: NSString(string: item.productImage)) {
            imageView.image = cachedImage
        } else {
            imageView.configureImage(url: item.productImage, cell, indexPath, collectionView)
        }
    }
    
    private func arrangeSubView() {
        stockLabel.textAlignment = .right
        
        subHorizontalStackView.addArrangedSubview(stockLabel)
        subHorizontalStackView.addArrangedSubview(accessaryImageView)
        
        horizontalStackView.addArrangedSubview(nameLabel)
        horizontalStackView.addArrangedSubview(subHorizontalStackView)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(priceLabel)
        
        entireStackView.addArrangedSubview(imageView)
        entireStackView.addArrangedSubview(verticalStackView)
        
        contentView.addSubview(entireStackView)
        
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            entireStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            entireStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            entireStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            
            accessaryImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.2)
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
    
    override func prepareForReuse(){
        super.prepareForReuse()
        stockLabel.textColor = .systemGray
        priceLabel.textColor = .systemRed
    }
}

extension CALayer {
    fileprivate func addBottomBorder() {
        let border = CALayer()
        border.backgroundColor = UIColor.systemGray3.cgColor
        
        border.frame = CGRect(x: 0, y: frame.height - 0.5, width: frame.width, height: 0.5)
        
        self.addSublayer(border)
    }
}
