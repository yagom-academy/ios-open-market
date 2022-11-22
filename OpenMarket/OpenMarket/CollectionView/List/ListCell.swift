//
//  ListCell.swift
//  OpenMarket
//
//  Created by 이정민 on 2022/11/22.
//

import UIKit

class ListCell: UICollectionViewListCell {
    let image: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var imageURL: String = ""
    
    let productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    let bargainPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    let stock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label

    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.contentView.addSubview(price)
         
        NSLayoutConstraint.activate([
            price.topAnchor.constraint(equalTo: contentView.topAnchor),
            price.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
