//
//  CellPotocol.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/18.
//

import UIKit

protocol ItemCellable where Self: UICollectionViewCell {
    func configureCell(items: [Item], indexPath: IndexPath)
    func configureImage(image: UIImage)
}
