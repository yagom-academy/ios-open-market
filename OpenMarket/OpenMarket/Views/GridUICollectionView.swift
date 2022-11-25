//
//  GridUICollectionView.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/11/22.
//

import UIKit

final class GridUICollectionView: UICollectionView {
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureGridDataSource(_ items: [Item]) {
        let cellRegisteration = UICollectionView.CellRegistration<GridCollectionViewCell, Item> { cell, indexPath, item in
            cell.updateWithItem(item)
        }
        self.gridDataSource = UICollectionViewDiffableDataSource(collectionView: self,
                                                        cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: item)
        })

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        self.gridDataSource.apply(snapshot, animatingDifferences: false)
    }
}
