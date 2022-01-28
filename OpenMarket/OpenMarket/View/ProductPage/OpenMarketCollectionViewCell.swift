//
//  CollectionViewLayoutCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

class OpenMarketCollectionViewCell: UICollectionViewCell {
    
    let productNameLabel = UILabel()
    let originalPriceLabel = UILabel()
    let bargainPriceLabel = UILabel()
    let accessoryImageView = UIImageView()
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        return stackView
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCellLayout()
    }
    
    private func configureCellLayout() {
        configureViewHirarchy()
        configureAutoLayout()
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func prepareForReuse() {
        bargainPriceLabel.isHidden = true
    }
    
    private func configureViewHirarchy() {
        self.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(productImageView)
        containerStackView.addArrangedSubview(productStackView)
        containerStackView.addArrangedSubview(stockLabel)
        
        productStackView.addArrangedSubview(productNameLabel)
        productStackView.addArrangedSubview(priceStackView)
        
        priceStackView.addArrangedSubview(originalPriceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            containerStackView.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            containerStackView.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerStackView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.2),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor)
        ])
        
        originalPriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bargainPriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        originalPriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bargainPriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    func configureContents(at indexPath: IndexPath, with item: Product) {
        
        URLSessionProvider(session: URLSession.shared).requestImage(from: item.thumbnail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.productImageView.image = data
                case .failure:
                    self.productImageView.image = UIImage(named: "Image")
                }
            }
        }
        
        productNameLabel.text = item.name
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        productNameLabel.adjustsFontForContentSizeCategory = true
        
        if item.stock > 0 {
            stockLabel.textColor = .systemGray
            stockLabel.text = "잔여수량 : \(item.stock)"
        } else {
            stockLabel.textColor = UIColor.systemOrange
            stockLabel.text = "품절"
        }
        
        if item.discountedPrice != 0 {
            originalPriceLabel.textColor = .systemRed
            let attributeString = NSMutableAttributedString(string: "\(item.currency) \(item.price)")
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 2,
                range: NSMakeRange(0, attributeString.length)
            )
            originalPriceLabel.attributedText = attributeString
            
            bargainPriceLabel.isHidden = false
            bargainPriceLabel.text = "\(item.currency) \(item.bargainPrice)"
            bargainPriceLabel.textColor = .systemGray
        } else {
            originalPriceLabel.text = "\(item.currency) \(item.bargainPrice)"
            originalPriceLabel.textColor = .systemGray
        }
    }
}
