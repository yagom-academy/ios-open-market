//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by marisol on 2022/05/16.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    var productImage: UIImageView = UIImageView()
    var productName: UILabel = UILabel()
    var currency: UILabel = UILabel()
    var price: UILabel = UILabel()
    var bargainPrice: UILabel = UILabel()
    var stock: UILabel = UILabel()
    
    private lazy var priceStackView = makeStackView(axis: .horizontal, alignment: .leading, distribution: .equalCentering, spacing: 5)
    private lazy var productStackView = makeStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var productWithImageStackView = makeStackView(axis: .horizontal, alignment: .fill, distribution: .fill, spacing: 5)
    private lazy var accessoryStackView = makeStackView(axis: .horizontal, alignment: .top, distribution: .fill, spacing: 5)
    
    private func makeStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.spacing = spacing
        
        return stackView
    }
    
    func configurePriceUI() {
        priceStackView.addArrangedSubview(currency)
        priceStackView.addArrangedSubview(price)
    }
    
    func configureProductUI() {
        productStackView.addArrangedSubview(productName)
        productStackView.addArrangedSubview(priceStackView)
    }
    
    func configureProductWithImageUI() {
        productWithImageStackView.addArrangedSubview(productImage)
        productWithImageStackView.addArrangedSubview(productStackView)
        productWithImageStackView.addArrangedSubview(accessoryStackView)
        self.addSubview(productWithImageStackView)
        
        NSLayoutConstraint.activate([
            productImage.widthAnchor.constraint(equalToConstant: 50),
            productImage.heightAnchor.constraint(equalTo: productImage.widthAnchor),
            productImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            productWithImageStackView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            productWithImageStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            productWithImageStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 5),
            productWithImageStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5)
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
        } else {
            label.text = "잔여수량: \(stock)"
        }
        
        button.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        label.textAlignment = .right
        
        accessoryStackView.addArrangedSubview(label)
        accessoryStackView.addArrangedSubview(button)
    }
}
