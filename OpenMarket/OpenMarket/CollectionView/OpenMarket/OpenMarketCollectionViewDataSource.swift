//
//  File.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/07.
//

import UIKit

class OpenMarketCollectionViewDataSource: NSObject {
    private var productList: [Product] = []
    private let networkManager = NetworkManager()
    private let parsingManager = ParsingManager()
    private var nextPage = 1
    private var changeIdentifier = ProductCell.listIdentifier
    private let compositionalLayout = CompositionalLayout()
    weak var loadingIndicator: LoadingIndicatable?
}

extension OpenMarketCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: changeIdentifier,
                for: indexPath) as? ProductCell else {
            return  UICollectionViewCell()
        }
        let productForItem = productList[indexPath.item]
        cell.productConfigure(product: productForItem, identifier: changeIdentifier)
        
        return cell
    }
    
    func requestProductList(_ collectionView: UICollectionView) {
        loadingIndicator?.startAnimating()
        loadingIndicator?.isHidden(false)
        self.networkManager.commuteWithAPI(
            api: GetItemsAPI(page: nextPage)) { result in
            if case .success(let data) = result {
                guard let product = try? self.parsingManager.decodedJSONData(type: ProductCollection.self, data: data) else {
                    return
                }
                self.productList.append(contentsOf: product.items)
                self.nextPage += 1
                DispatchQueue.main.async {
                    collectionView.reloadData()
                    self.loadingIndicator?.stopAnimating()
                    self.loadingIndicator?.isHidden(true)
                }
            }
        }
    }
    
    func decidedListLayout(_ collectionView: UICollectionView) {
        let listViewMargin =
            compositionalLayout.margin(top: 0, leading: 5, bottom: 0, trailing: 0)
        collectionView.collectionViewLayout =
            compositionalLayout.create(portraitHorizontalNumber: 1,
                                       landscapeHorizontalNumber: 1,
                                       cellVerticalSize: .absolute(100),
                                       scrollDirection: .vertical,
                                       cellMargin: nil, viewMargin: listViewMargin)
    }
    
    func selectedView(_ sender: UISegmentedControl,
                      _ collectionView: UICollectionView) {
        switch sender.selectedSegmentIndex {
        case 0:
            changeIdentifier = ProductCell.listIdentifier
            decidedListLayout(collectionView)
            collectionView.reloadData()
        default:
            changeIdentifier = ProductCell.gridItentifier
            let gridCellMargin = compositionalLayout.margin(
                top: 4, leading: 6, bottom: 4, trailing: 6)
            let gridViewMargin = compositionalLayout.margin(
                top: 4, leading: 0, bottom: 0, trailing: 0)
            collectionView.collectionViewLayout =
                compositionalLayout.create(
                    portraitHorizontalNumber: 2,
                    landscapeHorizontalNumber: 4,
                    cellVerticalSize: .absolute(250),
                    scrollDirection: .vertical,
                    cellMargin: gridCellMargin, viewMargin: gridViewMargin)
            collectionView.reloadData()
        }
    }
}

extension OpenMarketCollectionViewDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(
        _ collectionView: UICollectionView,
        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item == productList.count - 1 {
                requestProductList(collectionView)
            }
        }
    }
}
