//
//  GridLayoutCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

class GridLayoutCell: UICollectionViewCell {
    static var reuseIdentifier: String { "gridCell" }
    
    var stackView = UIStackView()
    var imageView = UIImageView()
    var productNameLabel = UILabel()
    var priceStackView = UIStackView()
    var priceLabel = UILabel()
    var stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureCellLayout() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
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
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(priceStackView)
        
        priceStackView.axis = .vertical
        priceStackView.alignment = .center
        priceStackView.distribution = .equalSpacing
        
        priceStackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(stockLabel)
    }
    
    override func prepareForReuse() {
        guard priceStackView.arrangedSubviews.count >= 2 else { return }
        guard let view = priceStackView.arrangedSubviews.first else { return }
        priceStackView.removeArrangedSubview(view)
    }

    func configureContents(imageURL: String, productName: String, price: String,
                           discountedPrice: String?, currency: Currency, stock: String) {
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
            
            let discountedLabel = UILabel()
            discountedLabel.text = "\(currency) \(discounted)"
            discountedLabel.textColor = .systemGray
            priceStackView.addArrangedSubview(discountedLabel)
        } else {
            priceLabel.text = "\(currency) \(price)"
            priceLabel.textColor = .systemGray
        }
    }
}
