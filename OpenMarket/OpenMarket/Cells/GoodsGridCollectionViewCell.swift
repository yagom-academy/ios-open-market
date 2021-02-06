//
//  GoodsGridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 김호준 on 2021/02/03.
//

import UIKit

class GoodsGridCollectionViewCell: MarketCell {
    @IBOutlet weak var cellView: UIView!
    
    override func configure(_ goods: Goods, isLast: Bool) {
        super.configure(goods, isLast: isLast)
        setupCellView()
    }
    
    //MARK: - setting entire cell's view
    private func setupCellView() {
        cellView.layer.borderWidth = 2.0
        cellView.layer.cornerRadius = 8
        cellView.layer.masksToBounds = false
        cellView.layer.borderColor = UIColor.systemGray2.cgColor
    }
}
