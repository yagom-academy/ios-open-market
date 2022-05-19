//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/16.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    private var productImage: UIImageView = UIImageView()
    private var productName: UILabel = UILabel()
    private var currency: UILabel = UILabel()
    private var price: UILabel = UILabel()
    private var bargainPrice: UILabel = UILabel()
    private var stock: UILabel = UILabel()
    
    private lazy var priceStackView = makeStackView(axis: .horizontal, alignment: .leading, distribution: .fillEqually, spacing: 5)
    private lazy var productStackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var entireProductStackView = makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var accessoryStackView = makeStackView(axis: .horizontal, alignment: .top, distribution: .fill, spacing: 5)
    
    private lazy var originalPrice: UILabel = {
        let label = UILabel()
        
        guard let currency = currency.text else {
            return UILabel()
        }
        
        guard let price = price.text else {
            return UILabel()
        }
        
        label.text = "\(currency) \(price)"
        label.textColor = .systemGray2
        
        return label
    }()
    
    private lazy var discountedPrice: UILabel = {
        let label = UILabel()
        
        guard let currency = currency.text else {
            return UILabel()
        }
        
        guard let bargainPrice = bargainPrice.text else {
            return UILabel()
        }
        
        label.text = "\(currency) \(bargainPrice)"
        label.textColor = .systemGray2
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.addSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = UIImage(systemName: "swift")
        productName.text = nil
        currency.text = nil
        price.text = nil
        bargainPrice.text = nil
        stock.text = nil
        accessoryStackView.removeFromSuperview()
    }
    
    func configureCell(_ products: Products) {
        if products.discountedPrice != 0 {
            setDiscountedPriceUI(products)
        }
        
        setCellUI(products)
        configurePriceUI()
        configureProductUI()
        configureAccessoryUI()
        configureEntireProductUI()
    }
}

// MARK: - setup UI
extension ListCollectionViewCell {
    private func setDiscountedPriceUI(_ products: Products) {
        let currency = products.currency
        let formattedPrice = formatNumber(price: products.price)
        let bargain = formatNumber(price: products.bargainPrice)
        
        originalPrice.text = currency + formattedPrice
        strikeThrough(price: originalPrice)
        discountedPrice.text = currency + bargain
    }
    
    private func setCellUI(_ products: Products) {
        let formattedPrice = formatNumber(price: products.price)
        
        productName.font  = UIFont.boldSystemFont(ofSize: 20)
        productName.text = products.name
        currency.text = products.currency
        price.text = formattedPrice
        stock.text = String(products.stock)
        
        guard let data = try? Data(contentsOf: products.thumbnail) else {
            return
        }
        
        productImage.image = UIImage(data: data)
    }
    
    private func configurePriceUI() {
        discountedPrice.textColor = .systemGray2
        
        priceStackView.addArrangedSubview(originalPrice)
        priceStackView.addArrangedSubview(discountedPrice)
    }
    
    private func configureProductUI() {
        productName.font = UIFont.preferredFont(forTextStyle: .title3)
        
        productStackView.addArrangedSubview(productName)
        productStackView.addArrangedSubview(priceStackView)
    }
    
    private func configureAccessoryUI() {
        let label = UILabel()
        let button = UIButton()
        
        guard let stock = stock.text else {
            return
        }
        
        if stock == "0" {
            label.text = "품절"
            label.textColor = .systemYellow
        } else {
            label.text = "잔여수량: \(stock)"
            label.textColor = .systemGray2
        }
        
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        button.tintColor = .systemGray2
        label.textAlignment = .right
        
        accessoryStackView.addArrangedSubview(label)
        accessoryStackView.addArrangedSubview(button)
    }
    
    private func configureEntireProductUI() {
        entireProductStackView.addArrangedSubview(productImage)
        entireProductStackView.addArrangedSubview(productStackView)
        entireProductStackView.addArrangedSubview(accessoryStackView)
        self.contentView.addSubview(entireProductStackView)
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalToConstant: 50),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            entireProductStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            entireProductStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            entireProductStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            entireProductStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - support UI
extension ListCollectionViewCell {
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    private func formatNumber(price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) else {
            return ""
        }
        
        return formattedPrice
    }

    private func strikeThrough(price: UILabel) {
        price.textColor = .systemRed
        price.attributedText = price.text?.strikeThrough()
    }
}
