//
//  ItemImageCollectionViewCell.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/12/08.
//

import UIKit

class ItemImageCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    override var reuseIdentifier: String {
        return String(describing: Self.self)
    }

    let imageView: UIImageView! = nil

   

}
