//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Wonbi on 2022/11/22.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    private var product: Product?
    private var productimage: UIImage?
    private var productName: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var price: UILabel?
    private var stock: UILabel?
    
    override var reuseIdentifier: String? {
        return "GridCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(from product: Product) {
        productName.text = product.name
        contentView.addSubview(productName)
        
        NSLayoutConstraint.activate([
            productName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productName.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
