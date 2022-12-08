//
//  GridCell.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/11/22.
//

import UIKit

final class GridCell: UICollectionViewCell {
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
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let stock: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [productName, price, stock])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 10
        [loadingView, productImage, labelStackView].forEach { contentView.addSubview($0) }
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
        loadingView.startAnimating()
    }
    
    private func setupCellConstraints() {
        let imageConstraints = (width: productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                                           constant: -20),
                                height: productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor))
        let loadingConstraints = (width: loadingView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                                            constant: -20),
                                  height: loadingView.heightAnchor.constraint(equalTo: loadingView.widthAnchor))
        imageConstraints.width.priority = UILayoutPriority(rawValue: 1000)
        imageConstraints.height.priority = UILayoutPriority(rawValue: 751)
        loadingConstraints.width.priority = UILayoutPriority(rawValue: 1000)
        loadingConstraints.height.priority = UILayoutPriority(rawValue: 751)
        
        NSLayoutConstraint.activate([
            loadingConstraints.height,
            loadingConstraints.width,
            loadingView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageConstraints.height,
            imageConstraints.width,
            productImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            labelStackView.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant:  10),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    func configure(from product: Product) {
        loadingView.startAnimating()
        self.identifier = product.identifier
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
            text = "\(currency) \(price)\n\(currency) \(bargainPrice)"
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
