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
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        configureDataSource()
        DataProvider.shared.fetchProductListData() { products in
            guard let products = products else {
                let alert = Alert().showWarning(title: "경고", message: "데이터를 불러올 수 없습니다", completionHandler: nil)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.updateSnapshot(products: products)
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
        DataProvider.shared.reloadData() { [weak self] products in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard let products = products else {
                    let alert = Alert().showWarning(title: "경고", message: "데이터를 불러올 수 없습니다", completionHandler: nil)
                    DispatchQueue.main.async { [weak self] in
                        self?.present(alert, animated: true)
                    }
                    return
                }
                guard var currentSnapshot = self?.currentSnapshot else {
                    return
                }
                currentSnapshot.appendItems(products)
                self?.dataSource?.apply(currentSnapshot)
                
                DispatchQueue.main.async { [weak self] in
                    self?.refreshControl.endRefreshing()
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.beginRefreshing()
            let emptySnapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            self?.dataSource?.apply(emptySnapshot)
        }
    }
}

// MARK: DiffableDataSource
@available(iOS 14.0, *)
extension MainViewController {
    private func registerCell() {
        listCellRegisteration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, item) in
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
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { [weak self] (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            if self?.baseView.segmentedControl.selectedSegmentIndex == 0 {
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
            DataProvider.shared.fetchProductListData() { products in
                guard let products = products else {
                    let alert = Alert().showWarning(title: "경고", message: "데이터를 불러올 수 없습니다", completionHandler: nil)
                    DispatchQueue.main.async { [weak self] in
                        self?.present(alert, animated: true)
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    self?.updateSnapshot(products: products)
                }
            }
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = dataSource?.itemIdentifier(for: indexPath) else { return }
                
        DataProvider.shared.fetchProductDetailData(productIdentifier: product.identifier) { decodedData in
            guard let decodedData = decodedData else {
                let alert = Alert().showWarning(title: "경고", message: "데이터를 불러오지 못했습니다", completionHandler: nil)
                
                DispatchQueue.main.async { [weak self] in
                    self?.present(alert, animated: true)
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                let registerProductView = UpdateProductViewController(product: decodedData)
                let navigationController = UINavigationController(rootViewController: registerProductView)
                navigationController.modalTransitionStyle = .coverVertical
                navigationController.modalPresentationStyle = .fullScreen
                self?.present(navigationController, animated: true)
            }
        }
    }
}
