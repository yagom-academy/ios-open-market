//
//  ListCellTableViewCell.swift
//  OpenMarket
//
//  Created by sole on 2021/02/04.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet weak var imagView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
}

class ResultCell: UICollectionViewCell {
    @IBOutlet weak var imagView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
}
