//
//  CellPotocol.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/18.
//

import UIKit

protocol ItemCellable {
    var itemImage: UIImage? { get set }
    var itemName: String { get set }
    var price: String { get set }
    var discountedPrice: Int { get set }
    var bargainPrice: String { get set }
    var stock: String { get set }
}
