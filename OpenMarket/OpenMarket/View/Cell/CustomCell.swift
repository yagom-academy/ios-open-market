//
//  CustomCell.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/20.
//

import UIKit

protocol CustomCell: UICollectionViewCell {
    func configure(data: Product)
}
