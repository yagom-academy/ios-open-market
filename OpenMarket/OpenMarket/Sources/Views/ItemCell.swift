//
//  ItemCell.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/21.
//

import UIKit

class ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "itemCell"

    private let itemImageView = ItemCellImageView(systemName: "photo")
    private let itemTitleLabel = ItemCellLabel(textStyle: .headline)
    private let priceLabel = ItemCellLabel(alpha: 0.5)
    private let discountedPriceLabel = ItemCellLabel(alpha: 0.5)
    private let stockLabel = ItemCellLabel(alpha: 0.5)
    private let disclosureIndicatorImageView = ItemCellImageView(systemName: "chevron.forward")

    private var item: Page.Item?

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
