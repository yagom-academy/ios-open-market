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
        stackView.alignment = .center
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
        contentView.layer.borderWidth = CGFloat(1)
        contentView.layer.cornerRadius = CGFloat(10)
        contentView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.addSubview(baseStackView)
        baseStackView.addArrangedSubviews(cellUIComponent.thumbnailImageView, cellUIComponent.nameLabel, cellUIComponent.priceLabel, cellUIComponent.bargainPriceLabel, cellUIComponent.stockLabel)
    }
    
    private func layout() {
        let thumbnail = cellUIComponent.thumbnailImageView
        
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            baseStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
        
        NSLayoutConstraint.activate([
            thumbnail.widthAnchor.constraint(equalToConstant: 50),
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
        cellUIComponent.bargainPriceLabel.text = product.currency + String(product.bargainPrice)
        cellUIComponent.priceLabel.text = product.currency + String(product.price)
        
        setUpStockLabel(stock: product.stock)
        setUpPriceLabel(price: product.price, bargainPrice: product.bargainPrice)
        
        guard let image = urlToImage(product.thumbnail) else { return }
        cellUIComponent.thumbnailImageView.image = image
    }
    
    func setUpStockLabel(stock: Int) {
        switch stock {
        case 0:
            cellUIComponent.stockLabel.text = "품절"
            cellUIComponent.stockLabel.textColor = .systemYellow
        default:
            cellUIComponent.stockLabel.text = String(stock)
        }
    }
    
    func setUpPriceLabel(price: Int, bargainPrice: Int) {
        switch bargainPrice == price {
        case true:
            cellUIComponent.bargainPriceLabel.isHidden = true
        case false:
            cellUIComponent.priceLabel.attributedText = cellUIComponent.priceLabel.text?.strikeThrough()
            cellUIComponent.priceLabel.textColor = .systemRed
        }
    }
    
    func urlToImage(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        return image
    }
}
