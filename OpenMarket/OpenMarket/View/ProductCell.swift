//
//  ProductCell.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/22.
//

import UIKit

extension UIConfigurationStateCustomKey {
    static let product = UIConfigurationStateCustomKey("product")
}

extension UIConfigurationState {
    var product: ProductData? {
        get { return self[.product] as? ProductData }
        set { self[.product] = newValue }
    }
}

class ProductCell: UICollectionViewListCell {
    var product: ProductData? = nil
    
    func updateWithProduct(_ newProduct: ProductData) {
        guard product != newProduct else { return }
        product = newProduct
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.product = self.product
        return state
    }
}
