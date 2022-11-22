//
//  ProductCell.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/22.
//

import UIKit

class ProductCell: UICollectionViewListCell {
    var listContentView: UIListContentView = UIListContentView(configuration: .cell())
    let stockLabel: UILabel = UILabel()
    var stockLabelConstraints: (stockLabelcenterY: NSLayoutConstraint,
                                stockLabelTrailing: NSLayoutConstraint)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        contentView.addSubview(listContentView)
        listContentView.addSubview(stockLabel)
        listContentView.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = (stockLabelcenterY: stockLabel.centerYAnchor.constraint(equalTo: listContentView.centerYAnchor),
                           stockLabelTrailing: stockLabel.trailingAnchor.constraint(equalTo: listContentView.trailingAnchor))
        
        NSLayoutConstraint.activate([
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            constraints.stockLabelcenterY,
            constraints.stockLabelTrailing
        ])
        
        stockLabelConstraints = constraints
    }
}
