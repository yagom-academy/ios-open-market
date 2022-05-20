//
//  Extension + UICollectionView.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/20.
//
import UIKit

extension UICollectionView {
    func setListPosition() {
        let offset = self.contentOffset
        self.setContentOffset(CGPoint(x: 0, y: offset.y + (self.frame.height * 0.25)), animated: false)
    }
    func setGirdPosition() {
        let offset = self.contentOffset
        self.setContentOffset(CGPoint(x: 0, y: offset.y - (self.frame.width * 0.8)), animated: false)
    }
}
