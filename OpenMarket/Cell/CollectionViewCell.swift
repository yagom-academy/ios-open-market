//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/17.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func update() {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
