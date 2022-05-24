//
//  CellPotocol.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/18.
//

import UIKit

protocol ItemCellable where Self: UICollectionViewCell {
    func configureCell(components: CellComponents)
}

struct CellComponents {
    let name: String
    let price: NSMutableAttributedString
    let isDiscounted: Bool
    let bargainPrice: String
    let stock: String
    let stockLabelColor: UIColor
    let thumbnailURL: String
}
