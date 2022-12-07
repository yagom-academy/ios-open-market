//
//  OpenMarketCollectionView.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/23.
//

import UIKit

protocol OpenMarketCollectionViewDelegate: AnyObject {
    func openMarketCollectionView(didRequestNextPage: Bool)
}

final class OpenMarketCollectionView: UICollectionView {
    //MARK: - Properties
    private var listCellRegistration: UICollectionView.CellRegistration<ProductListCell, Product>?
    private var gridCellRegistration: UICollectionView.CellRegistration<ProductGridCell, Product>?
    private var indicatorViewRegistration: UICollectionView.SupplementaryRegistration<IndicatorView>?
    private var openMarketDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    private var currentLayout: CollectionViewLayout = CollectionViewLayout.defaultLayout
    private var hasNextPage: Bool = true
    weak var openMarketDelegate: OpenMarketCollectionViewDelegate?
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Product>? {
        return openMarketDataSource?.snapshot()
    }
    
    init(frame: CGRect, collectionViewLayout layout: CollectionViewLayout) {
        super.init(frame: frame,
                   collectionViewLayout: LayoutMaker.make(of: layout))
        currentLayout = layout
        registerCell()
        registerSupplementaryView()
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
    func applyDataSource(using page: Page) {
        guard var currentSnapshot = currentSnapshot else {
            return
        }
        let products: [Product] = Array(page.products.prefix(page.productPerPage))

        self.hasNextPage = page.hasNextPage
        if currentSnapshot.numberOfSections == 0 {
            currentSnapshot.appendSections([.main])
        } else if page.number == 1 {
            currentSnapshot.deleteAllItems()
            currentSnapshot.appendSections([.main])
            scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: false)
        } else {
            currentSnapshot.deleteItems(products)
        }
        currentSnapshot.appendItems(products)
        openMarketDataSource?.apply(currentSnapshot)
        
        refreshControl?.endRefreshing()
    }
    //MARK: - Snapshot
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<Section, Product>) {
        openMarketDataSource?.apply(snapshot, animatingDifferences: false)
    }
    //MARK: - Cell
    private func registerCell() {
        listCellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, product) in
            cell.updateWithProduct(product)
            cell.setUpImage(from: product.thumbnail)
            cell.accessories = [.disclosureIndicator()]
        }
        
        gridCellRegistration = UICollectionView.CellRegistration<ProductGridCell, Product> { (cell, indexPath, product) in
            cell.updateWithProduct(product)
            cell.setUpImage(from: product.thumbnail)
        }
    }
    //MARK: - Footer
    private func registerSupplementaryView() {
        indicatorViewRegistration = UICollectionView.SupplementaryRegistration<IndicatorView>(elementKind: UICollectionView.elementKindSectionFooter) { [weak self] (supplementaryView, elementKind, indexPath) in
            if elementKind == UICollectionView.elementKindSectionFooter {
                if self?.hasNextPage == true {
                    self?.openMarketDelegate?.openMarketCollectionView(didRequestNextPage: true)
                    supplementaryView.startIndicator()
                }
            }
        }
    }
    //MARK: - DataSource
    private func configureDataSource() {
        guard let listCellRegistration = listCellRegistration,
              let gridCellRegistration = gridCellRegistration,
              let footerRegistration = indicatorViewRegistration else {
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
        
        openMarketDataSource?.supplementaryViewProvider = { (collectionView, identifier, indexPath) -> UICollectionReusableView in
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: indexPath)
        }
    }
}

