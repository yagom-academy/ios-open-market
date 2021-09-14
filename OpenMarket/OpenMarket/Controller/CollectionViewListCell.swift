//
//  CollectionViewListCell.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/14.
//

import UIKit

class CollectionViewListCell: UICollectionViewCell {
    static let cellID = "cellID"
    var imageView: UIImageView!
    var stackView: UIStackView!
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

    }
    private func setUpConstraints() {

    }
    private func setUpStyle() {

    }
}
