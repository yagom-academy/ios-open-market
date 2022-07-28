//
//  GridCell.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/18.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    // MARK: - properties
    
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let productName: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let price: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        
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
        [productName, price, stock].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setUpStackViewConstraints() {
        NSLayoutConstraint.activate(
            [productImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
             productImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
             productImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
             productImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5)])
        
        NSLayoutConstraint.activate(
            [stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
             stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
             stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)])
    }
    
    func setViewItems(_ item: ProductDetail) {
        OpenMarketRepository.makeImage(key: item.thumbnail, imageView: productImage)
        productName.text = item.name
        price.attributedText = item.makePriceText()
        stock.attributedText = item.makeStockText()
    }
}
