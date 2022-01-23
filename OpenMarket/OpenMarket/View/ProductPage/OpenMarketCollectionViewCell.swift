//
//  CollectionViewLayoutCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

class OpenMarketCollectionViewCell: UICollectionViewCell {
    
    var containerStackView = UIStackView()
    var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 2
        
        return stackView
    }()
    var imageView = UIImageView()
    var productStackView = UIStackView()
    var productNameLabel = UILabel()
    var priceStackView = UIStackView()
    var priceLabel = UILabel()
    var discountedLabel = UILabel()
    var stockLabel = UILabel()
    var accessoryImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonConfig()
    }
    
    private func commonConfig() {
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // 높이에다가 제약을 걸어준다!
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
        
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        discountedLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stockLabel.textAlignment = .right
        stockLabel.numberOfLines = 0
        
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    override func prepareForReuse() {
        discountedLabel.isHidden = true
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
