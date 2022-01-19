//
//  OpenMarketCollectionViewCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

class OpenMarketCollectionViewCell: UICollectionViewCell {
    
    var containerStackView = UIStackView()
    var stackView = UIStackView()
    var imageView = UIImageView()
    var productStackView = UIStackView()
    var productNameLabel = UILabel()
    var priceStackView = UIStackView()
    var priceLabel = UILabel()
    var bargainPriceLabel = UILabel()
    var stockLabel = UILabel()
    var accessoryImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
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
        productStackView.distribution = .equalSpacing
        productStackView.spacing = 2
        
        productStackView.addArrangedSubview(productNameLabel)

        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)

        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        bargainPriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
        bargainPriceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        stockLabel.textAlignment = .right
        stockLabel.numberOfLines = 0
        
        stockLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    override func prepareForReuse() {
        bargainPriceLabel.isHidden = true
    }
    
    func configureContents(with data: Product) {
        URLSessionProvider(session: URLSession.shared).requestImage(from: data.thumbnail) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.imageView.image = image
                case .failure:
                    self.imageView.image = UIImage(named: "Image")
                }
            }
        }
        
        productNameLabel.text = data.name
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        productNameLabel.adjustsFontForContentSizeCategory = true
        
        if data.stock > 0 {
            stockLabel.textColor = .systemGray
            stockLabel.text = "잔여수량 : \(data.stock)"
        } else {
            stockLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            stockLabel.text = "품절"
        }
        
        if data.discountedPrice != 0 {
            priceLabel.textColor = .systemRed
            let attributeString = NSMutableAttributedString(string: "\(data.currency) \(data.price)")
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 2,
                range: NSMakeRange(0, attributeString.length)
            )
            priceLabel.attributedText = attributeString
            
            bargainPriceLabel.isHidden = false
            bargainPriceLabel.text = "\(data.currency) \(data.bargainPrice)"
            bargainPriceLabel.textColor = .systemGray
        } else {
            priceLabel.attributedText = .none
            priceLabel.text = "\(data.currency) \(data.price)"
            priceLabel.textColor = .systemGray
        }
    }
}
