//
//  ProductCell.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/17.
//

import UIKit

protocol ProductCell: UICollectionViewCell {
    func configure(data: Product)
    func setImage(with image: UIImage)
}

extension ProductCell {
    static var identifier: String {
        return String(describing: self)
    }
}
