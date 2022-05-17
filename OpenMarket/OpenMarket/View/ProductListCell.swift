//
//  ProductListCell.swift
//  OpenMarket
//
//  Created by papri, Tiana on 17/05/2022.
//

import UIKit

class ProductListCell: UICollectionViewCell {
    static let reuseIdentifier = "product-list-cell-reuse-Identifier"
    let cellUIComponent = CellUIComponent()
    var showSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .placeholderText
        return view
    }()
    
    //MARK: - stackView
    private lazy var baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var productDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var nameAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductListCell {
    private func addSubViews() {
        contentView.addSubview(baseStackView)
        
        nameAndStockStackView.addArrangedSubviews(cellUIComponent.nameLabel, cellUIComponent.stockLabel)
        
        priceStackView.addArrangedSubviews(cellUIComponent.priceLabel, cellUIComponent.bargainPriceLabel)
        
        productDescriptionStackView.addArrangedSubviews(nameAndStockStackView, priceStackView)
        
        contentStackView.addArrangedSubviews(cellUIComponent.thumbnailImageView, productDescriptionStackView)
        
        baseStackView.addArrangedSubviews(contentStackView, separatorView)
    }
    
    private func layout() {
        let thumbnail = cellUIComponent.thumbnailImageView
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            thumbnail.widthAnchor.constraint(equalToConstant: safeAreaLayoutGuide.layoutFrame.width * 0.2),
            thumbnail.heightAnchor.constraint(equalTo: thumbnail.widthAnchor)
        ])
    }
}

extension ProductListCell {
    private func updateSeparator() {
        separatorView.isHidden = !showSeparator
    }
}
