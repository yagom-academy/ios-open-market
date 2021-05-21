//
//  ItemCell.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "itemCell"
    private var currentConstraints = [NSLayoutConstraint]()
    private var currentLayoutMode: LayoutMode = .current {
        didSet { toggleLayoutMode() }
    }

    private let imageView = ItemCellImageView(systemName: "photo")
    private let titleLabel = ItemCellLabel(textStyle: .headline)
    private let priceLabel = ItemCellLabel(alpha: 0.5)
    private let discountedPriceLabel = ItemCellLabel(alpha: 0.5)
    private let disclosureIndicatorImageView = ItemCellImageView(systemName: "chevron.forward")
    private let stockLabel = ItemCellLabel(alpha: 0.5)

    private var item: Page.Item?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()

        switch LayoutMode.current {
        case .list:
            addListConstraints()
            NSLayoutConstraint.activate(currentConstraints)
        case .grid:
            break
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func toggleLayoutMode() {
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()
        disclosureIndicatorImageView.isHidden.toggle()

        switch currentLayoutMode {
        case .list:
            addListConstraints()
            layer.cornerRadius = 0
        case .grid:
            addGridConstraints()
            layer.cornerRadius = 20
        }
    }

    func addSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(discountedPriceLabel)
        addSubview(disclosureIndicatorImageView)
        addSubview(stockLabel)
    }

    func addListConstraints() {
        let imageViewConstraints = [
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]

        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ]

        let priceLabelConstraints = [
            priceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
        ]

        let discountedPriceLabelConstraints = [
            discountedPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5),
            discountedPriceLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor)
        ]

        let disclosureIndicatorImageViewContraints = [
            disclosureIndicatorImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            disclosureIndicatorImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor)
        ]

        let stockLabelConstraints = [
            stockLabel.trailingAnchor.constraint(equalTo: disclosureIndicatorImageView.leadingAnchor, constant: -10),
            stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor)
        ]

        currentConstraints.append(contentsOf: imageViewConstraints)
        currentConstraints.append(contentsOf: titleLabelConstraints)
        currentConstraints.append(contentsOf: priceLabelConstraints)
        currentConstraints.append(contentsOf: discountedPriceLabelConstraints)
        currentConstraints.append(contentsOf: disclosureIndicatorImageViewContraints)
        currentConstraints.append(contentsOf: stockLabelConstraints)
    }

    func addGridConstraints() {}
}
