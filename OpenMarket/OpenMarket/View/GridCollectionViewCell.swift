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
        return imageView
    }()
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
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
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            productImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
        ])
    }
    
    private func setUpAttribute() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.cornerRadius = 10
    }
    
    func updateUI(data: Item, image: UIImage?) {
        productNameLabel.text = data.name
        productImageView.image = image
        
        if data.bargainPrice == 0 {
            productionPriceLabel.isHidden = true
            sellingPriceLabel.text = String(data.price)
        } else {
            productionPriceLabel.isHidden = false
            let underlineAttriString = NSAttributedString(
                string: String(data.price),
                attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            productionPriceLabel.attributedText = underlineAttriString
            sellingPriceLabel.text = String(data.bargainPrice)
        }
        
        stockLabel.text = String(data.stock)
    }
}
