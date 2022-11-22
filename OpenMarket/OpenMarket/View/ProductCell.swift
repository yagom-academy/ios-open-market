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
    var stockLabelConstraints: (stockLabelLeading: NSLayoutConstraint,
                                stockLabelTrailing: NSLayoutConstraint)?
    
    private func setUpViewsIfNeeded() {
        guard stockLabelConstraints == nil else {
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
        
        stockLabelConstraints = constraints
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setUpViewsIfNeeded()
        var content = UIListContentConfiguration.cell().updated(for: state)
        content.text = state.product?.name
        guard let url = URL(string: state.product!.thumbnail) else { return }
        let data = try! Data(contentsOf: url)
        
        content.image = UIImage(data: data)
        content.secondaryText = state.product?.price.description
        content.secondaryTextProperties.color = .systemGray
        stockLabel.text = state.product?.price.description
        stockLabel.textColor = .systemGray
        listContentView.configuration = content
    }
}
