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

    private lazy var productStackView = makeStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 5)
    
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

    private lazy var stockName: UILabel = {
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
    
    func makeBargainPrice(price: UILabel) {
        price.textColor = .systemRed
        price.attributedText = price.text?.strikeThrough()
    }
    
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    func configureProductUI() {
        productStackView.addArrangedSubview(productImage)
        productStackView.addArrangedSubview(productName)
        productStackView.addArrangedSubview(originalPrice)
        productStackView.addArrangedSubview(discountedPrice)
        productStackView.addArrangedSubview(stockName)
        self.contentView.addSubview(productStackView)
        
        NSLayoutConstraint.activate([
            productStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            productStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            productStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            productStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalToConstant: 100),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor)
        ])
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0,attributeString.length)
        )
        return attributeString
    }
}
