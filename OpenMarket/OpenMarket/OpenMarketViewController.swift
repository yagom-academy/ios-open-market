//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet private var openMarketCollectionView: UICollectionView!
    private var item: [Item] = []
    private var page: Int = 1
    private let networkHandler = NetworkHandler(session: URLSession.shared)
    
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
        let halfScreenWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        let oneThirdScreenHeight: CGFloat = UIScreen.main.bounds.height / 3.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize.width = halfScreenWidth - 15
        flowLayout.itemSize.height = oneThirdScreenHeight + 10
        return flowLayout
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

extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: OpenMarketGridCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketGridCell.cellIdentifier, for: indexPath) as? OpenMarketGridCell else { fatalError() }
        cell.setUpLabels(item: item, indexPath: indexPath)
        cell.setUpImages(url: item[indexPath.item].thumbnails[0])
        cell.configureCellStyle()
        return cell
    }
}
