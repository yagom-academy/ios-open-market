//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/21.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    private var identifier: String?
    
    private let loadingView: UIActivityIndicatorView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.systemGray.cgColor
        [loadingView, productImage, productStackView, stockStackView].forEach { contentView.addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        identifier = nil
        productImage.image = nil
        [productName, price, stock].forEach { $0?.text = nil }
        loadingView.isHidden = false
        productImage.isHidden = true
    }
    
    private func setupCellConstraints() {
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: bounds.height * 0.8),
            loadingView.widthAnchor.constraint(equalTo: loadingView.heightAnchor),
            
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            productImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            productImage.heightAnchor.constraint(equalToConstant: bounds.height * 0.8),
            productImage.widthAnchor.constraint(equalTo: productImage.heightAnchor),
            
            productStackView.leadingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: 10),
            productStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            productName.widthAnchor.constraint(equalToConstant: bounds.width * 0.48),
            
            stockStackView.topAnchor.constraint(equalTo: productStackView.topAnchor),
            stockStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            disclosureImage.heightAnchor.constraint(equalTo: stock.heightAnchor),
            disclosureImage.widthAnchor.constraint(equalTo: disclosureImage.heightAnchor),
        ])
    }
    
    func configureCell(from product: Product) {
        self.identifier = product.identifier
        loadingView.startAnimating()
        productName.text = product.name.isEmpty ? " " : product.name
        setupPrice(from: product)
        setupStock(from: product)
        setupImage(from: product)
        setupCellConstraints()
    }
    
    private func setupImage(from product: Product) {
        let cacheKey = NSString(string: product.thumbnail)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            productImage.image = cachedImage
            loadingView.stopAnimating()
            loadingView.isHidden = true
            productImage.isHidden = false
            return
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: product.thumbnail),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else {
                return
            }
            ImageCacheManager.shared.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async { [weak self] in
                guard product.identifier == self?.identifier else { return }
                
                self?.productImage.image = image
                self?.loadingView.stopAnimating()
                self?.loadingView.isHidden = true
                self?.productImage.isHidden = false
            }
        }
    }
    
    private func setupPrice(from product: Product) {
        let text: String
        let currency = product.currency.rawValue
        let price = FormatConverter.convertToDecimal(from: product.price)
        let bargainPrice = FormatConverter.convertToDecimal(from: product.bargainPrice)
        
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
        } else if product.stock >= 1000 {
            stock.textColor = .systemGray
            let stock = FormatConverter.convertToDecimal(from: Double(product.stock / 1000))
            self.stock.text = "잔여수량 : \(stock.components(separatedBy: ".")[0])k"
        } else {
            stock.textColor = .systemGray
            self.stock.text = "잔여수량 : \(product.stock)"
        }
    }
}
