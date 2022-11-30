//
//  OpenMarketCollectionView.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/23.
//

import UIKit

final class OpenMarketCollectionView: UICollectionView {
    //MARK: - Properties
    private var listCellRegistration: UICollectionView.CellRegistration<ProductListCell, Product>?
    private var gridCellRegistration: UICollectionView.CellRegistration<ProductGridCell, Product>?
    private var openMarketDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    private var currentLayout: CollectionViewLayout = CollectionViewLayout.defaultLayout
    
    init(frame: CGRect, collectionViewLayout layout: CollectionViewLayout) {
        super.init(frame: frame,
                   collectionViewLayout: LayoutMaker.make(of: layout))
        currentLayout = layout
        registerCell()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Layout
    func updateLayout(of layout: CollectionViewLayout) {
        setCollectionViewLayout(LayoutMaker.make(of: layout), animated: false)
        currentLayout = layout
    }
    //MARK: - Snapshot
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<Section, Product>) {
        openMarketDataSource?.apply(snapshot, animatingDifferences: false)
    }
    //MARK: - Cell
    private func registerCell() {
        listCellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, product) in
            cell.updateWithProduct(product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        gridCellRegistration = UICollectionView.CellRegistration<ProductGridCell, Product> { (cell, indexPath, product) in
            cell.updateWithProduct(product)
        }
    }
    //MARK: - DataSource
    private func configureDataSource() {
        guard let listCellRegistration = listCellRegistration,
              let gridCellRegistration = gridCellRegistration else {
            return
        }
        
        openMarketDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: self) { (collectionView: UICollectionView, indexPath: IndexPath, product: Product) -> UICollectionViewCell? in
            switch self.currentLayout {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: product)
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: product)
            case .imagePicker:
                return UICollectionViewCell()
            }
        }
    }
}
