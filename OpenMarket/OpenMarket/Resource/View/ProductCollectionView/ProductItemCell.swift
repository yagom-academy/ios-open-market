//
//  ProductItemCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class ProductItemCell: UICollectionViewCell {
    static let identifier = String(describing: ProductItemCell.self)
    var task: URLSessionDataTask? {
        didSet {
            if task != nil {
                task?.resume()
            }
        }
    }
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let stockLabel = UILabel()
    
    override func prepareForReuse() {
        thumbnailImageView.image = UIImage(systemName: "circle")
        task?.cancel()
        task = nil
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        super.prepareForReuse()
    }
}

// MARK: Configure Item Data
extension ProductItemCell {
    func configureLayout(index: Int) {
        [
            thumbnailImageView,
            titleLabel,
            subTitleLabel,
            stockLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        configureItemStyle(styleNumber: index)
        if index == 0 {
            setupLayoutListCell()
        } else {
            setupLayoutGridCell()
        }
    }
    
    func setStockLabelValue(stock: Int) {
        if stock <= 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "잔여수량 : \(stock)"
            stockLabel.textColor = .secondaryLabel
        }
    }
    
    func setPriceLabel(originPrice: String, bargainPrice: String, segment: Int) {
        let bargainPriceString = (segment == 0 ? " \(bargainPrice)" : "\n\(bargainPrice)")
        
        if bargainPrice != originPrice {
            let text = originPrice + bargainPriceString
            subTitleLabel.attributedText = text.convertAttributedString(target: originPrice)
        } else {
            subTitleLabel.text = originPrice
        }
    }
}

// MARK: Configure UI
private extension ProductItemCell {
    func setupLayoutListCell() {
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            
            titleLabel.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor, constant: -8),
            
            subTitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
            subTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stockLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stockLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    func setupLayoutGridCell(){
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            thumbnailImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: stockLabel.topAnchor),
            
            stockLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stockLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        subTitleLabel.setContentHuggingPriority(.init(1), for: .vertical)
    }
    
    func configureItemStyle(styleNumber: Int) {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        titleLabel.adjustsFontForContentSizeCategory = true
        
        titleLabel.textAlignment = (styleNumber == 0 ? .left : .center)
        
        subTitleLabel.textColor = .secondaryLabel
        subTitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subTitleLabel.adjustsFontForContentSizeCategory = true
        subTitleLabel.textAlignment = (styleNumber == 0 ? .left : .center)
        subTitleLabel.numberOfLines = 0

        stockLabel.textAlignment = (styleNumber == 0 ? .right : .center)
        stockLabel.textColor = .secondaryLabel
        stockLabel.numberOfLines = 2
        stockLabel.font = .preferredFont(forTextStyle: .subheadline)
        stockLabel.adjustsFontForContentSizeCategory = true
        
        thumbnailImageView.layer.cornerRadius = 20
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.borderColor = UIColor.gray.cgColor
        thumbnailImageView.layer.borderWidth = 0.1
        
        layer.cornerRadius = (styleNumber == 0 ? 0 : 20)
        layer.borderWidth = (styleNumber == 0 ? 0 : 2)
        layer.borderColor = (styleNumber == 0 ? nil : UIColor.gray.cgColor)
    }
}

// MARK: String +
private extension String {
    func convertAttributedString(target: String) -> NSMutableAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .subheadline)
        let range = (self as NSString).range(of: target)
        let attributeString = NSMutableAttributedString(string: self)
        
        attributeString.addAttribute(.strikethroughColor, value: UIColor.red, range: range)
        attributeString.addAttribute(.strikethroughStyle, value: 1, range: range)
        attributeString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        attributeString.addAttribute(.font, value: font, range: range)
        
        return attributeString
    }
}
