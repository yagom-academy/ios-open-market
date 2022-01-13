//
//  GridLayoutCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

protocol LayoutSwitchable: AnyObject {
    
    var isGridLayout: Bool { get set }
    
}

class GridLayoutCell: UICollectionViewCell {
    static var reuseIdentifier: String { "gridCell" }
    
    var containerStackView = UIStackView()
    var stackView = UIStackView()
    var imageView = UIImageView()
    var productStackView = UIStackView()
    var productNameLabel = UILabel()
    var priceStackView = UIStackView()
    var stockLabel = UILabel()
    
    weak var delegate: LayoutSwitchable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureCellLayout() {
        
        guard let delegate = delegate else {
            print("닐리리야")
            return
        }
        
        switch delegate.isGridLayout {
        case true:
            configureGridCellLayout()
        case false:
            configureListCellLayout()
        }
    }
    
    private func configureListCellLayout() {
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
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
        productStackView.addArrangedSubview(priceStackView)
        
        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.distribution = .equalSpacing
        priceStackView.spacing = 2
        
        stackView.addArrangedSubview(stockLabel)
    }
    
    private func configureGridCellLayout() {
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
        
        stackView.addArrangedSubview(stockLabel)
    }
    
    override func prepareForReuse() {
        priceStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
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
        
        let priceLabel = UILabel()
        priceStackView.addArrangedSubview(priceLabel)
        
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
