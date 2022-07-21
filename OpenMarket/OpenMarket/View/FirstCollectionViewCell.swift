//
//  CustomCollectionViewCell.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/15.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewListCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDiscountPrice: UILabel!
    @IBOutlet weak var productStock: UILabel!
    @IBOutlet weak var spacingView: UIView!
}
