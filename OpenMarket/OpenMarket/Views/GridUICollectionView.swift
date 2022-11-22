//
//  GridUICollectionView.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/11/22.
//

import UIKit

class GridUICollectionView: UICollectionView {
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Item>!


    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func configureGridDataSource(_ items: [Item]) {
        let cellRegisteration = UICollectionView.CellRegistration<GridCollectionViewCell, Item> { cell, indexPath, item in
            cell.configureData(item: item)
        }
        gridDataSource = UICollectionViewDiffableDataSource(collectionView: self,
                                                        cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: item)
        })

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        self.gridDataSource.apply(snapshot, animatingDifferences: false)
    }
}
