//
//  GridFlowLayout.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/28.
//

import UIKit

final class GridFlowLayout: UICollectionViewFlowLayout {
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

