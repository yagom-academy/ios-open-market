//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/18.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "GridCollectionViewCell"
    var productImage: UIImageView = UIImageView()
    var productName: UILabel = UILabel()
    var currency: UILabel = UILabel()
    var price: UILabel = UILabel()
    var bargainPrice: UILabel = UILabel()
    var stock: UILabel = UILabel()

    private lazy var productStackView = makeStackView(axis: .vertical, alignment: .center, distribution: .equalSpacing, spacing: 5)
    private lazy var priceStackView = makeStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 3)

    private lazy var originalPrice: UILabel = {
        let label = UILabel()
       
        guard let currency = currency.text else {
            return UILabel()
        }
        
        guard let price = price.text else {
            return UILabel()
        }
        
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
        
        label.textColor = .systemGray2
        
        return label
    }()

    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        
        guard let stock = stock.text else {
            return UILabel()
        }
        
        if stock == "0" {
            label.text = "품절"
            label.textColor = .systemYellow
            
        } else {
            label.text = "잔여수량: \(stock)"
            label.textColor = .systemGray2
        }
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        productName.text = nil
        currency.text = nil
        price.text = nil
        bargainPrice.text = nil
        stock.text = nil
    }
    
    func configureCell(_ products: Products) {
        if products.discountedPrice != 0 {
           setDiscountedPriceUI(products)
        } else {
            setOriginalPriceUI(products)
        }
        
        setCellUI(products)
        configureProductUI()
        configurePriceUI()
    }
}

// MARK: - setup UI
extension GridCollectionViewCell {
    private func setDiscountedPriceUI(_ products: Products) {
        let currency = products.currency
        let formattedPrice = formatNumber(price: products.price)
        let bargain = formatNumber(price: products.bargainPrice)
        
        originalPrice.text = currency + formattedPrice
        strikeThrough(price: originalPrice)
        discountedPrice.text = currency + bargain
        discountedPrice.textColor = .systemGray2
    }
    
    private func setOriginalPriceUI(_ products: Products) {
        let formattedPrice = formatNumber(price: products.price)
        let currency = products.currency
        
        originalPrice.text = "\(currency) \(formattedPrice)"
        originalPrice.textColor = .systemGray2
    }
    
    private func setCellUI(_ products: Products) {
        productName.font  = UIFont.boldSystemFont(ofSize: 20)
        productName.text = products.name
        stock.text = String(products.stock)
        
        guard let data = try? Data(contentsOf: products.thumbnail) else {
            return
        }
        
        productImage.image = UIImage(data: data)
    }
    
    private func configurePriceUI() {
        priceStackView.addArrangedSubview(originalPrice)
        priceStackView.addArrangedSubview(discountedPrice)
    }
    
    private func configureProductUI() {
        productStackView.addArrangedSubview(productImage)
        productStackView.addArrangedSubview(productName)
        productStackView.addArrangedSubview(priceStackView)
        productStackView.addArrangedSubview(stockLabel)
        self.contentView.addSubview(productStackView)
        
        NSLayoutConstraint.activate([
            productStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            productStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            productStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalToConstant: 100),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor)
        ])
    }
}

// MARK: - support UI
extension GridCollectionViewCell {
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    private func makeSeparator() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray5.cgColor
        self.layer.cornerRadius = 10
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
