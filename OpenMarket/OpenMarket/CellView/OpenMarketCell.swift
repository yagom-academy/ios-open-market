//
//  Contentable.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/17.
//

import UIKit

protocol OpenMarketCell {
    var productNameLabel: UILabel { get }
    var productPriceLabel: UILabel { get }
    var productBargainPriceLabel: UILabel { get }
    var productStockLabel: UILabel { get }
    var productImageView: UIImageView { get }
    
    func configureCellContents(product: Product)
}
