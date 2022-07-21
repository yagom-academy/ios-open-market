//
//  GridCollecntionView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import UIKit

final class GridCollecntionView: UICollectionView {
    // MARK: - properties
    
    private var gridViewDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>? = nil
    private let gridViewCellRegistration = UICollectionView.CellRegistration<GridCollectionViewCell, ProductDetail> {
        (cell, indexPath, item) in
        cell.setViewItems(item)
    }
    
    // MARK: - initializers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureDataSource()
    }
    
    // MARK: - functions
    
    private func configureDataSource() {
        gridViewDataSource = UICollectionViewDiffableDataSource<Section, ProductDetail>(collectionView: self) {
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: ProductDetail) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: self.gridViewCellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    func configureSnapshot(productsList: [ProductDetail]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductDetail>()
        snapshot.appendSections([.grid])
        snapshot.appendItems(productsList)
        
        gridViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
