//
//  ListCell.swift
//  OpenMarket
//
//  Created by Jpush, Aaron on 2022/11/22.
//

import UIKit

final class ListCell: UICollectionViewListCell {
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        label.attributedText = attributeString
        label.textColor = .systemRed
        
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemGray
        return label
    }()
    
    let nameStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
//        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
//        stackView.spacing = 8
        return stackView
    }()
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.accessories = [.disclosureIndicator()]
        
        self.contentView.addSubview(containerStackView)
        
        self.containerStackView.addArrangedSubview(image)
        self.containerStackView.addArrangedSubview(labelStackView)
        
        self.labelStackView.addArrangedSubview(nameStockStackView)
        self.labelStackView.addArrangedSubview(priceStackView)
        
        self.nameStockStackView.addArrangedSubview(productNameLabel)
        self.nameStockStackView.addArrangedSubview(stockLabel)
        
        self.priceStackView.addArrangedSubview(priceLabel)
        self.priceStackView.addArrangedSubview(bargainPriceLabel)
        
        setUpUI()
    }
    
    override func prepareForReuse() {
        image.image = nil
        productNameLabel.text = nil
        priceLabel.text = nil
        bargainPriceLabel.text = nil
        stockLabel.text = nil
        stockLabel.textColor = .systemGray
        priceLabel.isHidden = false
    }
    
    func setUpUI() {
        priceLabel.setContentHuggingPriority(.defaultHigh - 1, for: .horizontal)
        
//        productName.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            image.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/6),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
            
//            stock.widthAnchor.constraint(lessThanOrEqualTo: nameStockStackView.widthAnchor, multiplier: 0.4),
//
//            nameStockStackView.heightAnchor.constraint(greaterThanOrEqualTo: productName.heightAnchor)
//            stock.heightAnchor.constraint(greaterThanOrEqualTo: productName.heightAnchor),
//            productName.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6)
//            contentView.heightAnchor.constraint(greaterThanOrEqualTo: image.heightAnchor)
//            labelStackView.heightAnchor.constraint(greaterThanOrEqualTo: image.heightAnchor)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListCell {
    private func createStrikethroughAttribute() -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        
        return attributeString
    }
}
