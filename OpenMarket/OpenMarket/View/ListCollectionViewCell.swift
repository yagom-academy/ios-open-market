//
//  CollectionViewListCell.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/16.
//

import UIKit

final class ListCollectionViewCell: UICollectionViewListCell {
    
    private func defaultListConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    private var cellContentLayouts: [NSLayoutConstraint]?
    private lazy var listContentView = UIListContentView(configuration: .subtitleCell())
    private lazy var productImage = UIImageView()
    private let network = Network.shared
    private var lastDataTask: URLSessionDataTask?
    
    private let stock: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 2
        return label
    }()
    
    private func setConstraint() {
        guard cellContentLayouts == nil else { return }
        
        [listContentView, stock, productImage].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
                
        let layouts = [
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            productImage.widthAnchor.constraint(equalToConstant: 80),
            productImage.heightAnchor.constraint(equalToConstant: 80),
            productImage.trailingAnchor.constraint(equalTo: listContentView.leadingAnchor),
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stock.leadingAnchor.constraint(equalTo: listContentView.trailingAnchor),
            stock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stock.widthAnchor.constraint(equalTo: listContentView.widthAnchor, multiplier: 0.3),
            stock.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(layouts)
        cellContentLayouts = layouts
    }
    
    func configureContent(productInformation product: ProductInformation) {
        
        var configure = defaultListConfiguration()
        lastDataTask?.cancel()
        lastDataTask = network.setImageFromUrl(imageUrl: product.thumbnail, imageView: productImage)
        configure.text = product.name
        configure.textProperties.font = .preferredFont(forTextStyle: .headline)
        configure.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
        configure.secondaryTextProperties.color = .gray
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        switch product.currency {
        case Currency.KRW.rawValue:
            numberFormatter.maximumFractionDigits = 0
        default:
            numberFormatter.maximumFractionDigits = 1
        }
        
        let stringPrice = numberFormatter.string(for: product.price) ?? ""
        
        if product.discountedPrice == 0 {
            configure.secondaryText = "\(product.currency) \(stringPrice)"
        } else {
            let stringDiscountedPrice = numberFormatter.string(for: product.discountedPrice) ?? ""
            let letter = "\(product.currency) \(stringPrice)"
            let text = letter + " \(product.currency) \(stringDiscountedPrice)"
            configure.secondaryAttributedText = NSMutableAttributedString(allText: text, redText: letter)
        }
        
        listContentView.configuration = configure
        
        if product.stock == 0 {
            stock.text = "품절"
            stock.textColor = .orange
        } else {
            stock.text = "잔여수량: \(product.stock)"
            stock.textColor = .gray
        }
        setConstraint()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
    }
}

