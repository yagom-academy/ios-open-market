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
    private var item: Product? = nil
    
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

extension ProductGridCell {
    func updateWithItem(_ newItem: Product) {
        guard item != newItem else { return }
        item = newItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.item = self.item
        return state
    }
}

extension ProductGridCell {
    func setupViewsIfNeeded() {
        layout()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        
        guard let product = state.item else { return }
        
        cellUIComponent.nameLabel.text = product.name
        cellUIComponent.stockLabel.text = String(product.stock)
        cellUIComponent.bargainPriceLabel.text = String(product.bargainPrice)
        cellUIComponent.priceLabel.text = String(product.price)
        
        guard let image = urlToImage(product.thumbnail) else { return }
        cellUIComponent.thumbnailImageView.image = image
    }
    
    func urlToImage(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else { return nil }
        return image
    }
}
