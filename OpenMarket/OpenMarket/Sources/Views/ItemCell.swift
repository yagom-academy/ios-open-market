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

    private let imageView = ItemCellImageView(systemName: "photo")
    private let titleLabel = ItemCellLabel(textStyle: .headline)
    private let priceLabel = ItemCellLabel(alpha: 0.5)
    private let discountedPriceLabel = ItemCellLabel(alpha: 0.5)
    private let disclosureIndicatorImageView = ItemCellImageView(systemName: "chevron.forward")
    private let stockLabel = ItemCellLabel(alpha: 0.5)
    private let divisionLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()

    private var item: Page.Item?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()

        switch LayoutMode.current {
        case .list:
            activateListConstraints()
        case .grid:
            activateGridConstraints()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepareForReuse() {
        switch LayoutMode.current {
        case .list:
            activateListConstraints()
            disclosureIndicatorImageView.isHidden = false
            layer.cornerRadius = 0
        case .grid:
            activateGridConstraints()
            disclosureIndicatorImageView.isHidden = true
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
        addSubview(divisionLine)
    }

    func activateListConstraints() {
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()

        let imageViewConstraints = [
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
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

        let divisionLineCosntraints = [
            divisionLine.heightAnchor.constraint(equalToConstant: 1),
            divisionLine.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            divisionLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divisionLine.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]

        currentConstraints.append(contentsOf: imageViewConstraints)
        currentConstraints.append(contentsOf: titleLabelConstraints)
        currentConstraints.append(contentsOf: priceLabelConstraints)
        currentConstraints.append(contentsOf: discountedPriceLabelConstraints)
        currentConstraints.append(contentsOf: disclosureIndicatorImageViewContraints)
        currentConstraints.append(contentsOf: stockLabelConstraints)
        currentConstraints.append(contentsOf: divisionLineCosntraints)

        NSLayoutConstraint.activate(currentConstraints)
    }

    func activateGridConstraints() {
        NSLayoutConstraint.deactivate(currentConstraints)
        currentConstraints.removeAll()

        NSLayoutConstraint.activate(currentConstraints)
    }
}
