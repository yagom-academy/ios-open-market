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
    
    var listContentView: UIListContentView = UIListContentView(configuration: .cell())
    let stockLabel: UILabel = UILabel()
    var stockLableConstraints: (stockLabelLeading: NSLayoutConstraint,
                                stockLabelTrailing: NSLayoutConstraint)?
    
    private func setUpViewsIfNeeded() {
        guard stockLableConstraints == nil else {
            return
        }
        
        contentView.addSubview(listContentView)
        contentView.addSubview(stockLabel)
        listContentView.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = (stockLabelLeading: stockLabel.leadingAnchor.constraint(greaterThanOrEqualTo: listContentView.trailingAnchor),
                           stockLabelTrailing: stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor))
        
        NSLayoutConstraint.activate([
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            constraints.stockLabelLeading,
            constraints.stockLabelTrailing
        ])
        
        stockLableConstraints = constraints
    }
}
