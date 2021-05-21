//
//  OpenMarket - MarketItemsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MarketItemsViewController: UIViewController {
    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())

        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension MarketItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension MarketItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize()
    }
}

enum LayoutMode {
    static var current: LayoutMode = .list
    case list, grid

    static func toggle() {
        switch current {
        case .list: current = .grid
        case .grid: current = .list
        }
    }
}
