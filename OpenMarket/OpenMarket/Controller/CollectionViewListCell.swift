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
    private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
    private let stockLabel = UILabel()
    private var customViewConstraints: (stockLabelLeading: NSLayoutConstraint,
                                        stockLabelTrailing: NSLayoutConstraint)?

    func configureCell(item: Item) {
        setupViewsIfNeeded()
        var content = defaultListContentConfiguration()
        item.image { [weak self] image in
            DispatchQueue.main.async {
                content.image = image
                self?.listContentView.configuration = content
            }
        }

        content.text = item.title
        content.textProperties.numberOfLines = 1

        let priceWithCurrency = item.currency + " " + item.price.withDigit
        if let discountedPrice = item.discountedPrice {
            let discountedPriceWithCurrency = item.currency + " " + discountedPrice.withDigit
            content.secondaryAttributedText = priceWithCurrency.redStrikeThrough() + " " + discountedPriceWithCurrency
        } else {
            content.secondaryText = priceWithCurrency
        }
        content.secondaryTextProperties.color = .gray

        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
            stockLabel.textAlignment = .right
        } else {
            stockLabel.text = "잔여수량 : \(item.stock.withDigit)"
            stockLabel.textColor = .gray
            stockLabel.textAlignment = .left
        }

        listContentView.configuration = content
    }

    private func setupViewsIfNeeded() {
        guard customViewConstraints == nil else { return }

        contentView.addSubview(listContentView)
        contentView.addSubview(stockLabel)

        listContentView.translatesAutoresizingMaskIntoConstraints = false
        let defaultHorizontalCompressionResistance = listContentView.contentCompressionResistancePriority(for: .horizontal)
        listContentView.setContentCompressionResistancePriority(defaultHorizontalCompressionResistance - 1, for: .horizontal)
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)

        let constraints = (stockLabelLeading: stockLabel.leadingAnchor.constraint(equalTo: listContentView.trailingAnchor),
                           stockLabelTrailing: contentView.trailingAnchor.constraint(equalTo: stockLabel.trailingAnchor),
                           stockLabelWidthAnchor: stockLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        )

        NSLayoutConstraint.activate([
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listContentView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            stockLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            constraints.stockLabelLeading,
            constraints.stockLabelTrailing,
            constraints.stockLabelWidthAnchor
        ])
        accessories = [.disclosureIndicator()]
    }

    private func defaultListContentConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
}
