//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/20.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GridCell"
    
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
    
    private let preStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(preStackView)
        setStackView()
        setConstraints()
        
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    // MARK: Method
    private func setStackView() {
        preStackView.addArrangedSubview(productThumnail)
        preStackView.addArrangedSubview(productName)
        preStackView.addArrangedSubview(productPrice)
        preStackView.addArrangedSubview(productSalePrice)
        preStackView.addArrangedSubview(productStockQuntity)
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
