//
//  OpenMarketCell.swift
//  OpenMarket
//
//  Created by Ryan-Son on 2021/05/27.
//

import UIKit

protocol OpenMarketCell {
    var thumbnailImageView: UIImageView! { get set }
    var titleLabel: UILabel! { get set }
    var stockLabel: UILabel! { get set }
    var priceLabel: UILabel! { get set }
    var discountedPriceLabel: UILabel! { get set }
    var layer: CALayer { get }
}
