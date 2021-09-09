//
//  File.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/07.
//

import UIKit

class OpenMarketDataSource: NSObject {
    private var productList: [Product] = []
    private let networkManager = NetworkManager()
    private let parsingManager = ParsingManager()
    private var nextPage = 1
    private var changeIdentifier = ProductCell.listIdentifier
    weak var loadingIndicator: LoadingIndicatable?
}

extension OpenMarketDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: changeIdentifier, for: indexPath) as? ProductCell else {
            return  UICollectionViewCell()
        }
        let productForItem = productList[indexPath.row]
        cell.imageConfigure(product: productForItem)
        cell.textConfigure(product: productForItem)
        cell.styleConfigure(identifier: changeIdentifier)
        
        return cell
    }
    
    func requestProductList(collectionView: UICollectionView) {
        loadingIndicator?.startAnimating()
        self.networkManager.commuteWithAPI(api: GetItemsAPI(page: nextPage)) { result in
            if case .success(let data) = result {
                guard let product = try? self.parsingManager.decodedJSONData(type: ProductCollection.self, data: data) else {
                    return
                }
                self.productList.append(contentsOf: product.items)
                self.nextPage += 1
                DispatchQueue.main.async {
                    collectionView.reloadData()
                    self.loadingIndicator?.stopAnimating()
                }
            }
        }
    }
    
    func selectedView(_ sender: UISegmentedControl, _ collectionView: UICollectionView, _ compositionalLayout: CompositionalLayout) {
        switch sender.selectedSegmentIndex {
        case 0:
            changeIdentifier = ProductCell.listIdentifier
            collectionView.collectionViewLayout = compositionalLayout.create(portraitHorizontalNumber: 1, landscapeHorizontalNumber: 1, verticalSize: 100, scrollDirection: .vertical)
            collectionView.reloadData()
        default:
            changeIdentifier = ProductCell.gridItentifier
            collectionView.collectionViewLayout = compositionalLayout.create(portraitHorizontalNumber: 2, landscapeHorizontalNumber: 4, verticalSize: 250, scrollDirection: .vertical)
            collectionView.reloadData()
        }
    }
}

extension OpenMarketDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item == productList.count - 1 {
                requestProductList(collectionView: collectionView)
            }
        }
    }
}
