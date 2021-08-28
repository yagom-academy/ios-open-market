//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    
    private enum OpenMarketConstraint {
        static let deviceWidth = UIScreen.main.bounds.width
        static let deviceHeight = UIScreen.main.bounds.height
        static let minimumLineSpacing: CGFloat = 10
        static let minimumInteritemSpacing: CGFloat = 10
        static let inset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private var item: [Item] = []
    private var page: Int = 1
    private let networkHandler = NetworkHandler(session: URLSession.shared)
    
    @IBOutlet private var openMarketCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openMarketCollectionView.dataSource = self
        openMarketCollectionView.prefetchDataSource = self
        self.openMarketCollectionView.collectionViewLayout = configureFlowLayout()
        requestNextPage()
    }
    
    private func requestNextPage() {
        networkHandler.request(api: .getItemCollection(page: page)) { result in
            switch result {
            case .success(let data):
                guard let model = try? JsonHandler().decodeJSONData(json: data, model: ItemCollection.self) else { return }
                self.item.append(contentsOf: model.items)
                self.page += 1
                DispatchQueue.main.async {
                    self.openMarketCollectionView.reloadData()
                }
            default:
                break
            }
        }
    }
    
    private func configureFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = OpenMarketConstraint.inset
        flowLayout.minimumInteritemSpacing = OpenMarketConstraint.minimumInteritemSpacing
        flowLayout.minimumLineSpacing = OpenMarketConstraint.minimumLineSpacing
        flowLayout.itemSize.width = (OpenMarketConstraint.deviceWidth - (OpenMarketConstraint.minimumInteritemSpacing * 1 + OpenMarketConstraint.inset.left + OpenMarketConstraint.inset.right)) / 2
        flowLayout.itemSize.height = (OpenMarketConstraint.deviceHeight - OpenMarketConstraint.minimumLineSpacing * 2) / 3
        
        return flowLayout
    }
}

extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: OpenMarketGridCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketGridCell.cellIdentifier, for: indexPath) as? OpenMarketGridCell else { return UICollectionViewCell() }
        cell.setUpLabels(item: item, indexPath: indexPath)
        cell.setUpImages(url: item[indexPath.item].thumbnails[0])
        return cell
    }
}

extension OpenMarketViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let lastItem = item.count - 1
        for indexPath in indexPaths {
            if lastItem == indexPath.item {
                requestNextPage()
            }
        }
    }
}

