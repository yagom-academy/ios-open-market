//
//  GridCell.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/18.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    // MARK: - properties
    
    private var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var productName: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var price: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var stock: UILabel = {
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
    
    private func commonInit() {
        setUpSubViews()
        setUpStackViewConstraints()
        setUpBorder()
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
    
    private func setUpBorder() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.systemGray3.cgColor
    }
    
    func setViewItems(_ item: ProductDetail) {
        if let image = ImageCacheManager.shared.object(forKey: NSString(string: item.thumbnail)) {
            productImage.image = image
        } else {
            productImage.image = item.makeThumbnailImage()
        }
        productName.text = item.name
        price.attributedText = item.makePriceText()
        stock.attributedText = item.makeStockText()
    }
}
