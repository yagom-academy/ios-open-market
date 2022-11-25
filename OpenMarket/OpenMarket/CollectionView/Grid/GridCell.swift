//
//  ListCell.swift
//  OpenMarket
//
//  Created by Jpush, Aaron on 2022/11/24.
//

import UIKit

final class GridCell: UICollectionViewCell {
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        label.attributedText = attributeString
        label.textColor = .systemRed
        
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let bargainPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let stock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemGray
        return label
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center

        
        return stackView
    }()
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.contentView.addSubview(containerStackView)
        
        self.containerStackView.addArrangedSubview(image)
    
        self.containerStackView.addArrangedSubview(productName)
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderWidth = 2
        
        self.containerStackView.addArrangedSubview(priceStackView)
        
        self.priceStackView.addArrangedSubview(price)
        self.priceStackView.addArrangedSubview(bargainPrice)
        
        self.containerStackView.addArrangedSubview(stock)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        image.image = nil
        productName.text = nil
        price.text = nil
        bargainPrice.text = nil
        stock.text = nil
        stock.textColor = .systemGray
        price.isHidden = false
    }
    
    private func setUpUI() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            image.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            image.heightAnchor.constraint(equalTo: image.widthAnchor),
        ])
    }
}


