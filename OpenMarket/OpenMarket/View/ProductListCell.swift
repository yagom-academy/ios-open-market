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
    private var item: Product? = nil
    var showSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    
    private lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        let chevronImage = UIImage(systemName: "chevron.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = chevronImage
        imageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        return imageView
    }()
    
    lazy var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .placeholderText
        return view
    }()
    
    //MARK: - stackView
    private lazy var baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
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
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var nameStockAccessoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
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
        
        nameStockAccessoryStackView.addArrangedSubviews(cellUIComponent.nameLabel, cellUIComponent.stockLabel, accessoryImageView)

        priceStackView.addArrangedSubviews(cellUIComponent.priceLabel, cellUIComponent.bargainPriceLabel)
        
        productDescriptionStackView.addArrangedSubviews(nameStockAccessoryStackView, priceStackView)
        
        contentStackView.addArrangedSubviews(cellUIComponent.thumbnailImageView, productDescriptionStackView)
        
        baseStackView.addArrangedSubviews(contentStackView, seperatorView)
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
            thumbnail.widthAnchor.constraint(equalToConstant: 50),
            thumbnail.heightAnchor.constraint(equalTo: thumbnail.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            accessoryImageView.widthAnchor.constraint(equalToConstant: 13),
        ])
    }
}

extension ProductListCell {
    private func updateSeparator() {
        seperatorView.isHidden = !showSeparator
    }
}

extension ProductListCell {
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

fileprivate extension UIConfigurationStateCustomKey {
    static let item = UIConfigurationStateCustomKey("ProductListCell.item")
}

extension UICellConfigurationState {
    var item: Product? {
        set { self[.item] = newValue }
        get { return self[.item] as? Product }
    }
}

extension ProductListCell {
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
