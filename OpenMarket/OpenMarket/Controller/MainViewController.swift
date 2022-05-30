//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@available(iOS 14.0, *)
class MainViewController: BaseViewController {
    private var isFirstSnapshot = true
    private var listCellRegisteration: UICollectionView.CellRegistration<ProductListCell, Product>?
    private var gridCellRegisteration: UICollectionView.CellRegistration<ProductGridCell, Product>?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>?
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Product>?
    private let dataProvider = DataProvider()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        configureDataSource()
        dataProvider.fetchData() { products in
            DispatchQueue.main.async { [self] in
                updateSnapshot(products: products)
            }
        }
        collectionView?.delegate = self
        setUpRefreshControl()
    }
    
    // MARK: override function (non @objc)
    override func switchCollectionViewLayout() {
        super.switchCollectionViewLayout()
        self.configureDataSource()
        guard let currentSnapshot = currentSnapshot else {
            let alert = Alert().showWarning(title: "data 불러오지 못함")
            present(alert, animated: true)
            return
        }
        dataSource?.apply(currentSnapshot)
    }
    
    override func applyListLayout() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        listLayout = layout
    }
}

// MARK: Refresh Control
@available(iOS 14.0, *)
extension MainViewController {
    func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        refreshControl.tintColor = UIColor.systemPink

        collectionView?.refreshControl = refreshControl
    }
    
    @objc func refreshCollectionView() {
        dataProvider.reloadData() { [self] products in
            guard var currentSnapshot = currentSnapshot else {
                return
            }
            currentSnapshot.deleteItems(currentSnapshot.itemIdentifiers)
            currentSnapshot.appendItems(products)
            dataSource?.apply(currentSnapshot)
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
}

// MARK: DiffableDataSource
@available(iOS 14.0, *)
extension MainViewController {
    private func registerCell() {
        listCellRegisteration = UICollectionView.CellRegistration<ProductListCell, Product> { [self] (cell, indexPath, item) in
            guard let sectionIdentifier = currentSnapshot?.sectionIdentifiers[indexPath.section] else {
                return
            }
            let numberOfItemsInSection = currentSnapshot?.numberOfItems(inSection: sectionIdentifier)
            let isLastCell = indexPath.item + 1 == numberOfItemsInSection
            cell.seperatorView.isHidden = isLastCell
            
            cell.update(newItem: item)
        }
        
        gridCellRegisteration = UICollectionView.CellRegistration<ProductGridCell, Product> { (cell, indexPath, item) in
            cell.update(newItem: item)
        }
    }
    
    private func configureDataSource() {
        guard let collectionView = collectionView,
              let listCellRegisteration = listCellRegisteration,
              let gridCellRegisteration = gridCellRegisteration else {
            return
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { [self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            if baseView.segmentedControl.selectedSegmentIndex == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegisteration, for: indexPath, item: itemIdentifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegisteration, for: indexPath, item: itemIdentifier)
            }
        }
    }
    
    private func updateSnapshot(products: [Product]) {
        guard var currentSnapshot = dataSource?.snapshot() else { return }
        if isFirstSnapshot {
            currentSnapshot.appendSections([.main])
            isFirstSnapshot = false
        }
        currentSnapshot.appendItems(products)
        self.currentSnapshot = currentSnapshot
        dataSource?.apply(currentSnapshot)
    }
}

// MARK: UICollectionViewDelegate
@available(iOS 14.0, *)
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let product = currentSnapshot?.itemIdentifiers.last else {return}
        guard currentSnapshot?.indexOfItem(product) != indexPath.row else {
            dataProvider.fetchData() { products in
                DispatchQueue.main.async { [weak self] in
                    self?.updateSnapshot(products: products)
                }
            }
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        let registerProductView = UpdateProductViewController()
        let navigationController = UINavigationController(rootViewController: registerProductView)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        
        HTTPManager().loadData(targetURL: .productDetail(productNumber: product.identifier)) { productDetail in
            switch productDetail {
            case .success(let productDetail):
                guard let decodedData = try? JSONDecoder().decode(ProductDetail.self, from: productDetail) else {
                    return
                }
                registerProductView.initialize(product: decodedData)
                DispatchQueue.main.async { [self] in
                    present(navigationController, animated: true)
                }
            case .failure(_):
                return
            }
        }
    }
}
