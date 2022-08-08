//
//  UICollectionView+Extensions.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/08/07.
//

import UIKit

extension UICollectionView {
    var isBouncingBottom: Bool {
        return self.contentOffset.y > self.contentSize.height - self.bounds.size.height
    }
}
