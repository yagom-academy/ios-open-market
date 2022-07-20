//
//  GridCollectionCell.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
//

import UIKit

final class GridCollectionCell: UICollectionViewCell {
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
    private let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
    private let leftoverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureGridCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productNameLabel.text = nil
        originalPriceLabel.text = nil
        originalPriceLabel.textColor = .systemGray
        bargainPriceLabel.text = nil
        bargainPriceLabel.textColor = .systemGray
        leftoverLabel.text = nil
        leftoverLabel.textColor = .systemGray
    }
    
}

extension GridCollectionCell {
    private func configureGridCell() {
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubview(productImageView)
        rootStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(productNameLabel)
        labelStackView.addArrangedSubview(originalPriceLabel)
        labelStackView.addArrangedSubview(bargainPriceLabel)
        labelStackView.addArrangedSubview(leftoverLabel)

        let inset = CGFloat(10)
            
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
    
    func updateUI(_ data: ProductEntity) {
        productImageView.image = data.thumbnailImage
        productNameLabel.text = data.name
        originalPriceLabel.text = data.currency + " " + data.originalPrice.numberFormatter()
        originalPriceLabel.numberOfLines = 0
        bargainPriceLabel.text = data.currency + " " + data.discountedPrice.numberFormatter()
        bargainPriceLabel.numberOfLines = 0
        leftoverLabel.text = "잔여수량 : " + String(data.stock)
        
        if data.originalPrice == data.discountedPrice {
            bargainPriceLabel.isHidden = true
            originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(value: 0)
            originalPriceLabel.textColor = .systemGray
        } else {
            bargainPriceLabel.isHidden = false
            originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough(value: NSUnderlineStyle.single.rawValue)
            originalPriceLabel.textColor = .systemRed
        }
        
        if data.stock == 0 {
            leftoverLabel.text = "품절"
            leftoverLabel.textColor = .systemYellow
        }
    }
}
