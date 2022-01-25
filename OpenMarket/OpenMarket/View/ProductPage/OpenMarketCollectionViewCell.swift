//
//  CollectionViewLayoutCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

class OpenMarketCollectionViewCell: UICollectionViewCell {
    
    var containerStackView = UIStackView()
    var productNameLabel = UILabel()
    var priceLabel = UILabel()
    var discountedLabel = UILabel()
    var accessoryImageView = UIImageView()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        return stackView
    }()
    
    var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var stockLabel: UILabel = {
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
        discountedLabel.isHidden = true
    }
    
    private func configureViewHirarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(productStackView)
        stackView.addArrangedSubview(stockLabel)
        
        productStackView.addArrangedSubview(productNameLabel)
        productStackView.addArrangedSubview(priceStackView)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountedLabel)
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        discountedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        discountedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    func configureContents(at indexPath: IndexPath, with item: Product) {
        
        URLSessionProvider(session: URLSession.shared).requestImage(from: item.thumbnail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.imageView.image = data
                case .failure:
                    self.imageView.image = UIImage(named: "Image")
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
            priceLabel.textColor = .systemRed
            let attributeString = NSMutableAttributedString(string: "\(item.currency) \(item.price)")
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 2,
                range: NSMakeRange(0, attributeString.length)
            )
            priceLabel.attributedText = attributeString
            
            discountedLabel.isHidden = false
            discountedLabel.text = "\(item.currency) \(item.discountedPrice)"
            discountedLabel.textColor = .systemGray
        } else {
            priceLabel.text = "\(item.currency) \(item.price)"
            priceLabel.textColor = .systemGray
        }
    }
}
