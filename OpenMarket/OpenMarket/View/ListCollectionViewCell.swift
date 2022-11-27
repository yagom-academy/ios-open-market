//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/22.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    var product: Item?
    
    private let mainStackView = UIStackView()
    private let labelStackView = UIStackView()
    private let priceStackView = UIStackView()
    private var accessoryView = UIImageView()
    private let productImage = UIImageView()
    private let productNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let priceForSaleLabel = UILabel()
    private let stockLabel = UILabel()
    private let spacingView = UIView()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAttribute() {
        let priceHuggingPriority = priceForSaleLabel.contentHuggingPriority(for: .horizontal) + 1
        let stockHuggingPriority = productNameLabel.contentHuggingPriority(for: .horizontal) + 1
        let stockCompressionPriority = productNameLabel.contentCompressionResistancePriority(for: .horizontal) + 1
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.distribution = .equalSpacing
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        labelStackView.distribution = .equalSpacing
        labelStackView.axis = .horizontal
        priceStackView.distribution = .fill
        priceStackView.axis = .horizontal
        
        productNameLabel.textAlignment = .left
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stockLabel.setContentHuggingPriority(stockHuggingPriority, for: .horizontal)
        stockLabel.setContentCompressionResistancePriority(stockCompressionPriority, for: .horizontal)
        stockLabel.textAlignment = .right
        priceLabel.setContentHuggingPriority(priceHuggingPriority, for: .horizontal)
        priceLabel.isHidden = true
        spacingView.setContentHuggingPriority(priceHuggingPriority, for: .horizontal)
        priceForSaleLabel.textAlignment = .left
        
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView = image
        accessoryView.tintColor = .systemGray
    }
    
    private func configureLayout() {
        contentView.addSubview(loadingView)
        contentView.addSubview(productImage)
        contentView.addSubview(mainStackView)
        labelStackView.addArrangedSubview(productNameLabel)
        labelStackView.addArrangedSubview(stockLabel)
        labelStackView.addArrangedSubview(accessoryView)
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(spacingView)
        priceStackView.addArrangedSubview(priceForSaleLabel)
        
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            loadingView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 70),
            loadingView.widthAnchor.constraint(equalToConstant: 70),
            
            productImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            productImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            productImage.heightAnchor.constraint(equalToConstant: 70),
            productImage.widthAnchor.constraint(equalToConstant: 70),
            
            mainStackView.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
            mainStackView.centerYAnchor.constraint(equalTo: productImage.centerYAnchor),
            
            productNameLabel.leadingAnchor.constraint(equalTo: priceStackView.leadingAnchor),
            stockLabel.leadingAnchor.constraint(equalTo: productNameLabel.trailingAnchor, constant: 5),
            stockLabel.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -5),
            
            accessoryView.heightAnchor.constraint(equalToConstant: 17),
            accessoryView.widthAnchor.constraint(equalTo: accessoryView.heightAnchor),
            
            spacingView.widthAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    func configureContent(item: Item) {
        self.product = item
        
        spacingView.isHidden = true
        productNameLabel.text = "\(item.name)"
        priceLabel.text = .none
        priceLabel.attributedText = .none
        stockLabel.text = "잔여수량: \(item.stock)"
        stockLabel.textColor = .systemGray
        priceForSaleLabel.text = "\(item.currency) \(item.discountedPrice)"
        priceForSaleLabel.textColor = .systemGray
        
        if item.bargainPrice != 0 {
            spacingView.isHidden = false
            priceLabel.isHidden = false
            priceForSaleLabel.text = "\(item.currency) \(item.discountedPrice)"
            priceLabel.textColor = .systemRed
            priceLabel.text = "\(item.currency) \(item.price)"
            
            guard let priceText = priceLabel.text else { return }
            let attribute = NSMutableAttributedString(string: priceText)
            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
            priceLabel.attributedText = attribute
            priceForSaleLabel.textColor = .systemGray
        }
        
        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: item.thumbnail) else { return }
            NetworkManager.publicNetworkManager.getImageData(url: url) { image in
                DispatchQueue.main.async {
                    if item == self.product {
                        self.productImage.image = image
                        self.loadingView.stopAnimating()
                        self.loadingView.isHidden = true
                    }
                }
            }
        }
    }
}
