//
//  MainViewController+UpdateDelegate.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/12/05.
//

import UIKit

extension MainViewController: CollectionViewUpdateDelegate {
    func updateCollectionView() {
        let manager = NetworkManager()
        manager.getProductsList(pageNo: 1, itemsPerPage: 40) { productList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(productList.products)
            
            self.listDataSource?.apply(snapshot)
            self.gridDataSource?.apply(snapshot)
        }
    }
}

protocol CollectionViewUpdateDelegate {
    func updateCollectionView()
}
