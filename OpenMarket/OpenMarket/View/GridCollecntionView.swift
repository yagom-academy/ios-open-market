//
//  GridCollecntionView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import UIKit

class GridCollecntionView: UICollectionView {
    var gridViewDataSource: UICollectionViewDiffableDataSource<Section, ProductDetail>? = nil
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let gridViewCellRegistration = UICollectionView.CellRegistration<GridCollectionViewCell, ProductDetail> {
        (cell, indexPath, item) in
        cell.productImage.image = item.setThumbnailImage()
        cell.productName.text = item.name
        cell.price.attributedText = item.setPriceText()
        cell.stock.attributedText = item.setStockText()
    }
    
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
