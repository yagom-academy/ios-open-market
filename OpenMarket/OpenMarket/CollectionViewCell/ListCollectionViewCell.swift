//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/20.
//

import UIKit

class ListCollectionViewCell: UICollectionViewListCell {
    static let identifier = "ListCell"
    
    // MARK: Properties
    let productThumnail: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productSalePrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productStockQuntity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let downStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageStackView)
        contentView.addSubview(totalStackView)
        setStackView()
        setConstraints()
        
        self.accessories = [.disclosureIndicator()]
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func setStackView() {
        imageStackView.addArrangedSubview(productThumnail)
        totalStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(upperStackView)
        labelStackView.addArrangedSubview(downStackView)
        
        upperStackView.addArrangedSubview(productName)
        upperStackView.addArrangedSubview(productStockQuntity)
        
        downStackView.addArrangedSubview(productPrice)
        downStackView.addArrangedSubview(productSalePrice)
        
        productName.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        productStockQuntity.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        productPrice.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            imageStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            totalStackView.bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: 5),
            totalStackView.topAnchor.constraint(equalTo: imageStackView.topAnchor)
        ])
    }
}
