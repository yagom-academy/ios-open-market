//
//  CollectionViewListCell.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/14.
//

import UIKit

@available(iOS 14.0, *)
class CollectionViewListCell: UICollectionViewListCell {
    static let cellID = "ListCell"
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var priceLabel: UILabel!
    var discountedPriceLabel: UILabel!
    var stockLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        debugPrint("init Cell")
        setUpCellComponent()
        setUpConstraints()
        setUpStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpCellComponent() {
        imageView = UIImageView()
        titleLabel = UILabel()
        priceLabel = UILabel()
        discountedPriceLabel = UILabel()
        stockLabel = UILabel()

        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(priceLabel)
        self.contentView.addSubview(discountedPriceLabel)
        self.contentView.addSubview(stockLabel)
        self.accessories = [.disclosureIndicator()]
    }

    private func setUpConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.discountedPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stockLabel.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -5).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.17).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor).isActive = true

        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true

        discountedPriceLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor).isActive = true
        discountedPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5).isActive = true
        discountedPriceLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor).isActive = true

        stockLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        stockLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true

        let stockLabelWidthAnchor = stockLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25)
        stockLabelWidthAnchor.isActive = true
        stockLabelWidthAnchor.priority = .init(999)
    }

    private func setUpStyle() {
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        priceLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        discountedPriceLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize)
        stockLabel.font = UIFont.systemFont(ofSize: 14)
    }

    func configureCell(item: Item) {
        item.image { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }

        titleLabel.text = item.title
        let priceWithCurrency = item.currency + " " + item.price.withDigit

        if let discountedPrice = item.discountedPrice {
            priceLabel.attributedText = priceWithCurrency.strikeThrough()
            priceLabel.textColor = .red
            discountedPriceLabel.text = item.currency + " " + discountedPrice.withDigit
            discountedPriceLabel.textColor = .gray
            discountedPriceLabel.isHidden = false
        } else {
            priceLabel.text = priceWithCurrency
            priceLabel.textColor = .gray
        }

        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = "잔여수량 : \(item.stock.withDigit)"
            stockLabel.textColor = .gray
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = .none
        priceLabel.attributedText = nil
        discountedPriceLabel.text = .none
        discountedPriceLabel.isHidden = true
    }
}
