//
//  GridCollecntionView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import UIKit

final class GridCollecntionView: UICollectionView {
    // MARK: - properties
    
    private var gridViewDataSource: UICollectionViewDiffableDataSource<Section, ProductInformation>? = nil
    private let gridViewCellRegistration = UICollectionView.CellRegistration<GridCollectionViewCell, ProductInformation> {
        (cell, indexPath, product) in
        cell.setViewItems(product)
    }
    
    // MARK: - initializers
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupDataSource()
    }
    
    // MARK: - functions
    
    private func setupDataSource() {
        gridViewDataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: self) { [weak self]
            (collectionView: UICollectionView,
             indexPath: IndexPath,
             identifier: ProductInformation) -> UICollectionViewCell? in
            
            guard let gridViewCellRegistration = self?.gridViewCellRegistration
            else { return UICollectionViewCell() }
            
            return collectionView.dequeueConfiguredReusableCell(using: gridViewCellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    func setSnapshot(productsList: [ProductInformation]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections([.grid])
        snapshot.appendItems(productsList)
        
        gridViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func deleteSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.deleteAllItems()
        
        gridViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
