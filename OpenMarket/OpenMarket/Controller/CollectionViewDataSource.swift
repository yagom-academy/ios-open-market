//
//  collectionViewDataSource.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/09/12.
//

import UIKit

@available(iOS 14.0, *)
class CollectionViewDataSource: NSObject, UICollectionViewDataSource {
    private var items: [Item] = []
    private let networkManager = NetworkManager()
    private var page: Int = 1

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if CollectionViewProperty.shared.isListView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewListCell.cellID, for: indexPath) as? CollectionViewListCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(item: items[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewGridCell.cellID, for: indexPath) as? CollectionViewGridCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(item: items[indexPath.item])
            return cell
        }
    }

    func requestNextPage(collectionView: UICollectionView) {
        networkManager.commuteWithAPI(API.GetItems(page: page)) { result in
            if case .success(let data) = result {
                guard let data = try? JSONDecoder().decode(Items.self, from: data) else {
                    return
                }
                self.items.append(contentsOf: data.items)
                self.page += 1

                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
}

@available(iOS 14.0, *)
extension CollectionViewDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.last?.row == items.count - 1 {
            debugPrint(indexPaths.last?.row)
            debugPrint("requestNextPage")
            guard let cell = collectionView.dataSource as? CollectionViewDataSource else {
                return
            }
            cell.requestNextPage(collectionView: collectionView)
        }
    }
}
