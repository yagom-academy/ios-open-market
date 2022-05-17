//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/16.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        setUpAttribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        makeConstraints()
        setUpAttribute()
    }
    
    override func prepareForReuse() {
        productImageView.image = nil
        productNameLabel.text = ""
        indicatorView.startAnimating()
    }
    
    private lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImageView, productNameLabel, productionPriceLabel, sellingPriceLabel, stockLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var productionPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sellingPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.textAlignment = .center
        return label
    }()
    
    private func addSubviews() {
        contentView.addSubview(productStackView)
        contentView.addSubview(indicatorView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 0),
            indicatorView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 0),
            indicatorView.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 0),
            indicatorView.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            productNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
        ])
    }
    
    private func setUpAttribute() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.cornerRadius = 10
    }
    
    func updateLabel(data: Item) {
        productNameLabel.text = data.name
        
        if data.discountedPrice == 0 {
            productionPriceLabel.isHidden = true
            sellingPriceLabel.update(with: data.currency, price: data.price)
        } else {
            productionPriceLabel.isHidden = false
            productionPriceLabel.addStrikeThrough(price: data.price)
            productionPriceLabel.update(with: data.currency, price: data.bargainPrice)
            sellingPriceLabel.update(with: data.currency, price: data.bargainPrice)
        }
        
        stockLabel.textColor = data.stock == 0 ? .systemOrange : .systemGray
        stockLabel.text = data.stock == 0 ? "품절 " : "잔여수량 : \(data.stock) "
    }
    
    func updateImage(image: UIImage?) {
        productImageView.image = image
        indicatorView.stopAnimating()
    }
}
