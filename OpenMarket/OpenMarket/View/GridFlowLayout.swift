//
//  GridFlowLayout.swift
//  OpenMarket
//
//  Created by dhoney96 on 2022/07/28.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {
    let numberOfColumns = 2
    
    override init() {
        super.init()
        self.scrollDirection = .vertical
        self.minimumLineSpacing = 5
        self.minimumInteritemSpacing = 5
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

