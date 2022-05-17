//
//  ProductGridCell.swift
//  OpenMarket
//
//  Created by papri, Tiana on 17/05/2022.
//

import UIKit

class ProductGridCell: UICollectionViewCell {
    static let reuseIdentifier = "product-grid-cell-reuse-Identifier"
    let cellUIComponent = CellUIComponent()
    
    //MARK: - stackView
    private lazy var baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
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

extension ProductGridCell {
    private func addSubViews() {
        contentView.addSubview(baseStackView)
        baseStackView.addArrangedSubviews(cellUIComponent.thumbnailImageView, cellUIComponent.nameLabel, cellUIComponent.priceLabel, cellUIComponent.bargainPriceLabel, cellUIComponent.stockLabel)
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
            thumbnail.widthAnchor.constraint(equalToConstant: safeAreaLayoutGuide.layoutFrame.width * 0.4),
            thumbnail.heightAnchor.constraint(equalTo: thumbnail.widthAnchor)
        ])
    }
}
