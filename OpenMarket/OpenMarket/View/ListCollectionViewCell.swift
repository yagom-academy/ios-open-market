//
//  GridCell.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/18.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    // MARK: - properties
    
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        return imageView
    }()
    
    private let productName: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    private let stock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let accessoryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.widthAnchor.constraint(equalToConstant: 8).isActive = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let accessoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        
        return stackView
    }()
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - functions
    override func prepareForReuse() {
        productImage.image = nil
        productName.text = nil
        price.attributedText = nil
        stock.attributedText = nil
    }
    
    private func commonInit() {
        setUpSubViews()
        setUpStackViewConstraints()
        self.setUpBoder(cornerRadius: 10, borderWidth: 1.5, borderColor: UIColor.systemGray3.cgColor)
    }
    
    private func setUpSubViews() {
        self.contentView.addSubview(productImage)
        self.contentView.addSubview(stackView)
        self.contentView.addSubview(accessoryStackView)
        [productName, price].forEach { stackView.addArrangedSubview($0) }
        [stock, accessoryImage].forEach { accessoryStackView.addArrangedSubview($0) }
    }
    
    private func setUpStackViewConstraints() {
        NSLayoutConstraint.activate(
            [productImage.topAnchor.constraint(equalTo: self.contentView.topAnchor),
             productImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
             productImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
             productImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor)])
        
        NSLayoutConstraint.activate(
            [stackView.leadingAnchor.constraint(equalTo: self.productImage.trailingAnchor, constant: 10),
             stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
             stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor)])
        
        NSLayoutConstraint.activate(
            [accessoryStackView.leadingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
             accessoryStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
             accessoryStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
             accessoryStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            ])
    }
    
    func setViewItems(_ item: ProductDetail) {
        OpenMarketRepository.makeImage(key: item.thumbnail, imageView: productImage)
        productName.text = item.name
        price.attributedText = item.makePriceText()
        stock.attributedText = item.makeStockText()
    }
}
