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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .label
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    override func prepareForReuse() {
        thumbnailImageView.image = UIImage(systemName: "circle")
        task?.cancel()
        task = nil
        
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        super.prepareForReuse()
    }
    
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
        
        if index == 0 {
            setupLayoutListCell()
        } else {
            configureGridItemStyle()
            setupLayoutGridCell()
        }
        
    }
    
    private func setupLayoutListCell() {
        func setupLayoutOfThumbnailImageView() {
            NSLayoutConstraint.activate([
                thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                thumbnailImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor)
            ])
        }
        
        func setupLayoutOfTitleLabel() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: stockLabel.leadingAnchor, constant: -8)
            ])
        }
        
        func setupLayoutOfSubTitleLabel() {
            NSLayoutConstraint.activate([
                subTitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
                subTitleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 8),
                subTitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
            ])
        }
        
        func setupLayoutOfStockLabel() {
            NSLayoutConstraint.activate([
                stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
                stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                stockLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                stockLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                stockLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25)
            ])
        }
        
        setupLayoutOfThumbnailImageView()
        setupLayoutOfTitleLabel()
        setupLayoutOfSubTitleLabel()
        setupLayoutOfStockLabel()
    }
    
    private func setupLayoutGridCell(){
        func setupLayoutOfThumbnailImageView() {
            NSLayoutConstraint.activate([
                thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                thumbnailImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            ])
        }
        
        func setupLayoutOfTitleLabel() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(lessThanOrEqualTo: thumbnailImageView.bottomAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
        
        func setupLayoutOfSubTitleLabel() {
            NSLayoutConstraint.activate([
                subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                subTitleLabel.bottomAnchor.constraint(equalTo: stockLabel.topAnchor)
            ])
            subTitleLabel.setContentHuggingPriority(.init(1), for: .vertical)
        }
        
        func setupLayoutOfStockLabel() {
            NSLayoutConstraint.activate([
                stockLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                stockLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                stockLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
        }
        
        setupLayoutOfThumbnailImageView()
        setupLayoutOfTitleLabel()
        setupLayoutOfSubTitleLabel()
        setupLayoutOfStockLabel()
    }
    
    private func configureGridItemStyle() {
        [titleLabel, subTitleLabel, stockLabel].forEach {
            $0.textAlignment = .center
        }
        
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        
        subTitleLabel.textColor = .secondaryLabel
        subTitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        stockLabel.textColor = .secondaryLabel
        stockLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        thumbnailImageView.layer.cornerRadius = 20
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.borderColor = UIColor.gray.cgColor
        thumbnailImageView.layer.borderWidth = 0.1
        
        layer.cornerRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
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
    
    func setPriceLabel(currency: String, price: Double, bargainPrice: Double, segment: Int) {
         if bargainPrice != price {
             let text = "\(currency) \(price) \(currency) \(bargainPrice)"
             let textCancleLine = "\(currency) \(price)"
             
             let font = UIFont.preferredFont(forTextStyle: .subheadline)
             
             let attributeString = NSMutableAttributedString(string: text)
             attributeString.addAttribute(.strikethroughColor, value: UIColor.red, range: (text as NSString).range(of: textCancleLine))
             attributeString.addAttribute(.strikethroughStyle, value: 1, range: (text as NSString).range(of: textCancleLine))
             attributeString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: textCancleLine))
             attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: textCancleLine))
             subTitleLabel.attributedText = attributeString
         } else {
             subTitleLabel.textColor = .secondaryLabel
             
             subTitleLabel.text = "\(currency) \(price)"
         }
     }
}
