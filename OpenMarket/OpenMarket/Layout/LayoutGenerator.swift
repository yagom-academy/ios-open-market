//
//  LayoutGenerator.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/24.
//

import UIKit

//MARK:- CollectionView's Layout Object
struct Layout {
    static func generate(_ view: UIView) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.width / 2.2
        let height = view.bounds.height / 3.6
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return layout
    }
}
