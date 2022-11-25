//  GridCollectionViewCell.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/25.

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "gridCell"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(discountedPriceLabel)
        
        return stack
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        
        stack.addArrangedSubview(productImageView)
        stack.addArrangedSubview(productNameLabel)
        stack.addArrangedSubview(priceStackView)
        stack.addArrangedSubview(stockLabel)
        
        return stack
    }()
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.95),
            productImageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.6),
            productNameLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            priceLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            discountedPriceLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1),
            stockLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.1)
        ])
    }
    
    func updateContents(_ product: Product) {
        DispatchQueue.main.async {
            guard let url = URL(string: product.thumbnailURL),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                      return
                  }
            self.productImageView.image = image
        }
        
        productNameLabel.text = product.name
        priceLabel.text = product.currency.rawValue + " (product.price)"
        discountedPriceLabel.text = product.currency.rawValue + " (product.discountedPrice)"
        stockLabel.text = "잔여수량 : (product.stock)"
    }
}
