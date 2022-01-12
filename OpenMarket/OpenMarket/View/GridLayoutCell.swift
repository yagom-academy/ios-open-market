//
//  GridLayoutCell.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/11.
//

import UIKit

class GridLayoutCell: UICollectionViewCell {
    static var reuseIdentifier: String { "gridCell" }
    
    var stackView = UIStackView()
    var imageView = UIImageView()
    var productNameLabel = UILabel()
    var priceStackView = UIStackView()
    var priceLabel = UILabel()
    var stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureCellLayout() {
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)])
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(productNameLabel)
        stackView.addArrangedSubview(priceStackView)
        
        priceStackView.axis = .vertical
        priceStackView.alignment = .center
        priceStackView.distribution = .equalSpacing
        
        priceStackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(stockLabel)
    }
    
    override func prepareForReuse() {
        guard priceStackView.arrangedSubviews.count >= 2 else { return }
        guard let view = priceStackView.arrangedSubviews.first else { return }
        priceStackView.removeArrangedSubview(view)
    }

    func configureContents(image: UIImage, productName: String, price: String, discountedPrice: String?, stock: String) {
        imageView.image = image
        productNameLabel.text = productName
        priceLabel.text = price
        stockLabel.text = stock
        
        if let discounted = discountedPrice {
            priceLabel.textColor = .systemRed
            let attributeString = NSMutableAttributedString(string: price)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            priceLabel.attributedText = attributeString
            let discountedLabel = UILabel()
            discountedLabel.text = discounted
            priceStackView.addArrangedSubview(discountedLabel)
        }
    }
}
