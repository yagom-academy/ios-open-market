//
//  OpenMarketDataSource.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

class OpenMarketDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    override init() {
        super.init()
        let loadData = OpenMarketLoadData()
        loadData.requestOpenMarketMainPageData(page: "\(page)") { testData in
            self.openMarketItemList = [testData]
            self.page += 1
        }
        
        while self.openMarketItemList.count == 0 {
            continue
        }
    }

    var openMarketItemList = [OpenMarketItems]()
    private var page: Int = 1
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        openMarketItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        openMarketItemList[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "openMarketCell", for: indexPath) as? OpenMarketItemCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(item: self.openMarketItemList[indexPath.section].items[indexPath.item], indexPath)
        
        return cell
    }
    
    //MARK:
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let item = (openMarketItemList.first?.items.count ?? .zero) - 3
        indexPaths.forEach { indexPath in
            if item == indexPath.item {
                OpenMarketLoadData().requestOpenMarketMainPageData(page: "\(page)") { items in
                    self.openMarketItemList.append(items)
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            }
        }
        
        
    }
    
}
