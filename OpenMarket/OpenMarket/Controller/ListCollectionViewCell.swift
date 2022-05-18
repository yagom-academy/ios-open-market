//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/16.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    var productImage: UIImageView = UIImageView()
    var productName: UILabel = UILabel()
    var currency: UILabel = UILabel()
    var price: UILabel = UILabel()
    var bargainPrice: UILabel = UILabel()
    var stock: UILabel = UILabel()
    
    private lazy var priceStackView = makeStackView(axis: .horizontal, alignment: .leading, distribution: .fillEqually, spacing: 5)
    private lazy var productStackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var productWithImageStackView = makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var accessoryStackView = makeStackView(axis: .horizontal, alignment: .top, distribution: .fill, spacing: 5)
    
    lazy var originalPrice: UILabel = {
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
    
    lazy var discountedPrice: UILabel = {
        let label = UILabel()
       
        guard let currency = currency.text else {
            return UILabel()
        }
        
        guard let price = bargainPrice.text else {
            return UILabel()
        }
        
        label.text = "\(currency) \(price)"
        label.textColor = .systemGray2
        
        return label
    }()
    
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    func makeBargainPrice(price: UILabel) {
        price.textColor = .systemRed
        price.attributedText = price.text?.strikeThrough()
    }
    
    func configurePriceUI() {
        priceStackView.addArrangedSubview(originalPrice)
        priceStackView.addArrangedSubview(discountedPrice)
        
        discountedPrice.textColor = .systemGray2
    }
    
    func configureProductUI() {
        productStackView.addArrangedSubview(productName)
        productStackView.addArrangedSubview(priceStackView)
        
        productName.font = UIFont.preferredFont(forTextStyle: .title3)
    }
    
    func configureProductWithImageUI() {
        productWithImageStackView.addArrangedSubview(productImage)
        productWithImageStackView.addArrangedSubview(productStackView)
        productWithImageStackView.addArrangedSubview(accessoryStackView)
        self.contentView.addSubview(productWithImageStackView)
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalToConstant: 50),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            productWithImageStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            productWithImageStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            productWithImageStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            productWithImageStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }

    func configureAccessoryStackView() {
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
}
