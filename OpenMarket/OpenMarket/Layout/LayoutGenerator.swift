//
//  LayoutGenerator.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/24.
//

import UIKit

struct Layout {
    static func generate(_ view: UIView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let width = view.bounds.width / 2.5
        let height = view.bounds.height / 2
        
        layout.itemSize = CGSize(width: width, height: height)
        
        return layout
    }
}
