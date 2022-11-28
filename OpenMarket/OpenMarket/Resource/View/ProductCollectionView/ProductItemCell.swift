//
//  ProductItemCell.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import UIKit

class ProductItemCell: UICollectionViewCell {
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
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 0.1
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    override func prepareForReuse() {
        thumbnailImageView.image = UIImage(systemName: "circle")
        task?.cancel()
        task = nil
        
        super.prepareForReuse()
    }
    
    func configureLayout() {
        [
            thumbnailImageView,
            titleLabel,
            subTitleLabel,
            stockLabel
        ].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func configureStyle() { }
}

// MARK: Configure Item Data
extension ProductItemCell {
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
            subTitleLabel.attributedText = text.convertCancelLineString(target: originPrice)
        } else {
            subTitleLabel.text = originPrice
        }
    }
}

// MARK: String +
private extension String {
    func convertCancelLineString(target: String) -> NSMutableAttributedString {
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
