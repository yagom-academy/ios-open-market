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
    private let pageNumber = 1
    private var changeIdentifier = ProductCell.listIdentifier
}

extension OpenMarketDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: changeIdentifier, for: indexPath) as? ProductCell else {
            return  UICollectionViewCell()
        }
        let productForItem = productList[indexPath.item]
        cell.imageConfigure(product: productForItem)
        cell.textConfigure(product: productForItem)
        cell.styleConfigure(identifier: changeIdentifier)
        
        return cell
    }
    
    func requestProductList(collectionView: UICollectionView) {
        self.networkManager.commuteWithAPI(api: GetItemsAPI(page: pageNumber)) { result in
            if case .success(let data) = result {
                guard let product = try? self.parsingManager.decodedJSONData(type: ProductCollection.self, data: data) else {
                    return
                }
                self.productList.append(contentsOf: product.items)
                
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    func selectedView(_ sender: UISegmentedControl, _ collectionView: UICollectionView, _ compositionalLayout: CompositionalLayout) {
        switch sender.selectedSegmentIndex {
        case 0:
            changeIdentifier = ProductCell.listIdentifier
            collectionView.collectionViewLayout = compositionalLayout.creat(portraitHorizontalNumber: 1, landscapeHorizontalNumber: 1, verticalSize: 100, scrollDirection: .vertical)
            collectionView.reloadData()
        default:
            changeIdentifier = ProductCell.gridItentifier
            collectionView.collectionViewLayout = compositionalLayout.creat(portraitHorizontalNumber: 2, landscapeHorizontalNumber: 4, verticalSize: 250, scrollDirection: .vertical)
            collectionView.reloadData()
        }
    }
}
