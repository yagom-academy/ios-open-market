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
    private var imageFetchTask: URLSessionDataTask?
    var showSeparator = true {
        didSet {
            updateSeparator()
        }
    }
    
    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        let chevronImage = UIImage(systemName: "chevron.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = chevronImage
        imageView.tintColor = UIColor.lightGray.withAlphaComponent(0.7)
        return imageView
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .placeholderText
        return view
    }()
    
    //MARK: - stackView
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private let productDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let nameStockAccessoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
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
            baseStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:  10),
            baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant:  -10),
            baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            thumbnail.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            thumbnail.heightAnchor.constraint(lessThanOrEqualToConstant: 60),
            thumbnail.widthAnchor.constraint(equalTo: thumbnail.heightAnchor)
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
    func update(newItem: Product) {
        guard item != newItem else { return }
        item = newItem
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
    private func setupViewsIfNeeded() {
        layout()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let product = state.item else { return }
        
        cellUIComponent.nameLabel.text = product.name
        cellUIComponent.bargainPriceLabel.text = product.currency + String(product.bargainPrice)
        cellUIComponent.priceLabel.text = product.currency + String(product.price)
        
        setUpStockLabel(stock: product.stock)
        setUpPriceLabel(price: product.price, bargainPrice: product.bargainPrice)
        
        imageFetchTask = DataProvider().fetchImage(urlString: product.thumbnail) { [self] image in
            DispatchQueue.main.async { [self] in
                cellUIComponent.thumbnailImageView.image = image
            }
        }
    }
    
    private func setUpStockLabel(stock: Int) {
        switch stock {
        case 0:
            cellUIComponent.stockLabel.text = "품절"
            cellUIComponent.stockLabel.textColor = .systemYellow
        default:
            cellUIComponent.stockLabel.text = "잔여수량 : " + String(stock)
        }
    }
    
    private func setUpPriceLabel(price: Int, bargainPrice: Int) {
        switch bargainPrice == price {
        case true:
            cellUIComponent.bargainPriceLabel.isHidden = true
        case false:
            cellUIComponent.priceLabel.attributedText = cellUIComponent.priceLabel.text?.strikeThrough()
            cellUIComponent.priceLabel.textColor = .systemRed
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageFetchTask?.cancel()
        cellUIComponent.stockLabel.textColor = .systemGray
        cellUIComponent.priceLabel.textColor = .systemGray
        cellUIComponent.bargainPriceLabel.isHidden = false
        cellUIComponent.priceLabel.attributedText = nil
    }
}
