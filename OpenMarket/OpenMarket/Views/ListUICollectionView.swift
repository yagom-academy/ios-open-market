//
//  ListUICollectionView.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/11/22.
//

import UIKit

class ListUICollectionView: UICollectionView {
    var listDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureListDataSource(_ items: [Item]) {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Item> { (cell, indexPath, item) in
            cell.updateWithItem(item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        self.listDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        self.listDataSource.apply(snapshot, animatingDifferences: false)
    }
}
 
