//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/20.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    static let identifier = "ListCell"
    
    // MARK: Properties
    private let productThumnail: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productSalePrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productStockQuntity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let preStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(preStackView)
        setStackView()
        setConstraints()
        
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    private func setStackView() {
        preStackView.addArrangedSubview(productThumnail)
        preStackView.addArrangedSubview(productStackView)
        preStackView.addArrangedSubview(productStockQuntity)
        
        productStackView.addArrangedSubview(productName)
        productStackView.addArrangedSubview(priceStackView)
        
        priceStackView.addArrangedSubview(productPrice)
        priceStackView.addArrangedSubview(productSalePrice)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            preStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            preStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            preStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            preStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
