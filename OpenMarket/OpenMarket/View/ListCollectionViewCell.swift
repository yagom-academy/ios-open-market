//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/16.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        makeConstraints()
    }
    
    override func prepareForReuse() {
        productImageView.image = nil
        productNameLabel.text = ""
    }
    
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, informationStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productNameLabel, stockLabel])
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray2
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productionPriceLabel, sellingPriceLabel])
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var sellingPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var productionPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func addSubviews() {
        contentView.addSubview(productStackView)
        contentView.addSubview(bottomLineView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: productStackView.heightAnchor),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
    
    func updateLabel(data: Item) {
        productNameLabel.text = data.name
        
        if data.discountedPrice == 0 {
            productionPriceLabel.isHidden = true
            sellingPriceLabel.toDecimal(with: data.currency, price: data.price)
        } else {
            productionPriceLabel.isHidden = false
            productionPriceLabel.addStrikeThrough(price: data.price)
            sellingPriceLabel.toDecimal(with: data.currency, price: data.bargainPrice)
        }
        
        stockLabel.text = String(data.stock)
    }
    
    func updateImage(image: UIImage?) {
        productImageView.image = image
    }
}
