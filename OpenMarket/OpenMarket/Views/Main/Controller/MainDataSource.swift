//
//  MainDataSource.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/20.
//

import UIKit

class MainDataSource: NSObject {
    private(set) var products: Products?
    private(set) var productList: [Product] = []
    var currentCellIdentifier = ProductCell.listIdentifier
    var currentPage: UInt = 1
    
    func setUpProducts(_ products: Products) {
        self.products = products
    }
    
    func resetCurrentPage() {
        currentPage = 1
    }
    
    func appendProducts(_ products: [Product]) {
        self.productList.append(contentsOf: products)
    }
 
    func updateProductList() {
        guard let products = products else {
            return
        }
        productList = products.pages
    }
}

extension MainDataSource: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return productList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: currentCellIdentifier,
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }
        cell.configureStyle(of: currentCellIdentifier)
        cell.configureProduct(of: productList[indexPath.row])
        return cell
    }
}
