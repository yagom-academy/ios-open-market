//
//  GoodsListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Wonhee on 2021/02/03.
//

import UIKit

class GoodsListCollectionViewCell: MarketCell {
    @IBOutlet weak var barView: UIView!
    
    override func configure(_ goods: Goods, isLast: Bool) {
        super.configure(goods, isLast: isLast)
        
        barView.isHidden = isLast
    }
}
