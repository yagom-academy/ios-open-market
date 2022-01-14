//
//  CollectionViewLayoutCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

class CollectionViewLayoutCell: UICollectionViewCell {
    
    var containerStackView = UIStackView()
    var stackView = UIStackView()
    var imageView = UIImageView()
    var productStackView = UIStackView()
    var productNameLabel = UILabel()
    var priceStackView = UIStackView()
    var priceLabel = UILabel()
    var discountedLabel = UILabel()
    var stockLabel = UILabel()
    var accessoryImageView = UIImageView()
    
    var isGridLayout: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func commonConfig() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 2
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        stackView.addArrangedSubview(productStackView)
        productStackView.axis = .vertical
        productStackView.alignment = .leading
        productStackView.distribution = .equalSpacing
        productStackView.spacing = 2
        
        productStackView.addArrangedSubview(productNameLabel)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountedLabel)
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        discountedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        productStackView.addArrangedSubview(priceStackView)
        
        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.distribution = .equalSpacing
        stockLabel.textAlignment = .right
        stockLabel.numberOfLines = 0
        stackView.addArrangedSubview(stockLabel)
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stackView.addArrangedSubview(accessoryImageView)
        accessoryImageView.image = UIImage(systemName: "chevron.right")
        accessoryImageView.tintColor = .systemGray
        
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        discountedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stockLabel.textAlignment = .right
        stockLabel.numberOfLines = 0
        
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func configureCellLayout() {
        
        switch isGridLayout {
        case true:
            configureGridCellLayout()
        case false:
            configureListCellLayout()
        }
    }
    
    private func configureListCellLayout() {
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2)
        ])
        priceStackView.axis = .horizontal
    }
    
    private func configureGridCellLayout() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9)
        ])
        priceStackView.axis = .vertical
    }
    
    override func prepareForReuse() {
        discountedLabel.isHidden = true
    }
    
    func configureContents(imageURL: String, productName: String, price: String,
                           discountedPrice: String?, currency: Currency, stock: String) {
        
        configureCellLayout()
        
        URLSessionProvider(session: URLSession.shared).requestImage(from: imageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.imageView.image = data
                case .failure:
                    self.imageView.image = UIImage(named: "Image")
                }
            }
        }
        
        productNameLabel.text = productName
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        productNameLabel.adjustsFontForContentSizeCategory = true
        
        if let intStock = Int(stock), intStock > 0 {
            stockLabel.textColor = .systemGray
            stockLabel.text = "잔여수량 : \(stock)"
        } else {
            stockLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            stockLabel.text = "품절"
        }
        
        if let discounted = discountedPrice {
            priceLabel.textColor = .systemRed
            let attributeString = NSMutableAttributedString(string: "\(currency) \(price)")
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 2,
                range: NSMakeRange(0, attributeString.length)
            )
            priceLabel.attributedText = attributeString
            
            discountedLabel.isHidden = false
            discountedLabel.text = "\(currency) \(discounted)"
            discountedLabel.textColor = .systemGray
        } else {
            priceLabel.text = "\(currency) \(price)"
            priceLabel.textColor = .systemGray
        }
    }
}
