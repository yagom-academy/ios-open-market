//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/21.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    private var product: Product?
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }()
    
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stock: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let disclosureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.compact.right")
        imageView.tintColor = .systemGray4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stockStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [stock, disclosureImage])
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var productStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [productName, price])
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override var reuseIdentifier: String? {
        return "ListCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [activityIndicatorView, productImage, productStackView, stockStackView].forEach { contentView.addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        productImage.image = nil
        [productName, price, stock].forEach { $0?.text = nil }
    }
    
    func setupCellConstraints() {
        NSLayoutConstraint.activate([
            activityIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: bounds.height * 0.8),
            activityIndicatorView.widthAnchor.constraint(equalTo: activityIndicatorView.heightAnchor),
            
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            productImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImage.heightAnchor.constraint(equalToConstant: bounds.height * 0.8),
            productImage.widthAnchor.constraint(equalTo: productImage.heightAnchor),
            
            productStackView.leadingAnchor.constraint(equalTo: activityIndicatorView.trailingAnchor, constant: 10),
            productStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            productName.widthAnchor.constraint(equalToConstant: bounds.width * 0.48),
            
            stockStackView.topAnchor.constraint(equalTo: productStackView.topAnchor),
            stockStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            disclosureImage.heightAnchor.constraint(equalTo: stock.heightAnchor),
            disclosureImage.widthAnchor.constraint(equalTo: disclosureImage.heightAnchor),
        ])
    }
    
    func configureCell(from product: Product) {
        activityIndicatorView.startAnimating()
        productName.text = product.name
        setupPrice(from: product)
        setupStock(from: product)
        
        setupCellConstraints()
    }
    
    private func setupImage(from product: Product) {
        
    }
    
    private func setupPrice(from product: Product) {
        let text: String
        let currency = product.currency.rawValue
        let price = FormatConverter.number(from: product.price)
        let bargainPrice = FormatConverter.number(from: product.bargainPrice)
        
        if product.discountedPrice.isZero {
            text = "\(currency) \(price)"
            self.price.textColor = .systemGray
            self.price.text = text
        } else {
            text = "\(currency) \(price) \(currency) \(bargainPrice)"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([.foregroundColor: UIColor.systemRed, .strikethroughStyle: 1],
                                           range: (text as NSString).range(of: "\(currency) \(price)"))
            attributedString.addAttributes([.foregroundColor: UIColor.systemGray],
                                           range: (text as NSString).range(of: "\(currency) \(bargainPrice)"))
            self.price.attributedText = attributedString
        }
    }
    
    private func setupStock(from product: Product) {
        if product.stock.isZero {
            stock.textColor = .systemOrange
            stock.text = "품절"
        } else if product.stock.decimal >= 4 {
            stock.textColor = .systemGray
            let stock = FormatConverter.number(from: Double(product.stock / 1000))
            self.stock.text = "잔여수량 : \(stock.components(separatedBy: ".")[0])k"
        } else {
            stock.textColor = .systemGray
            self.stock.text = "잔여수량 : \(product.stock)"
        }
    }
}
