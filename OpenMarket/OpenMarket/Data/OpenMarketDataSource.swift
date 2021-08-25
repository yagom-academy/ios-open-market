//
//  OpenMarketDataSource.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

class OpenMarketDataSource: NSObject {
    
    //MARK: Property
    private var rquestPage: Int = 1
    private let nextPage = 1
    private var isLoading = false

    var openMarketItemList = [OpenMarketItems]()
    
    override init() {
        super.init()
        
        OpenMarketLoadData.requestOpenMarketMainPageData(page: "\(rquestPage)") { openMarketItems in
            self.openMarketItemList = [openMarketItems]
            self.rquestPage += self.nextPage
        }
        
        //MARK: Stop initializing OpenMarketDataSource instance until get openMarketItemList
        while self.openMarketItemList.count == 0 {
            continue
        }
    }
}

extension OpenMarketDataSource: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegate {
    
    //MARK: UICollectionViewDataSource Method
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
    
    //MARK: UICollectionViewDataSourcePrefetching Method
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        let almostEndPoint = 1
//        let item = (openMarketItemList.first?.items.count ?? .zero) - almostEndPoint
//
//        indexPaths.forEach { indexPath in
//            if item == indexPath.item {
//                OpenMarketLoadData.requestOpenMarketMainPageData(page: "\(rquestPage)") { items in
//                    self.openMarketItemList.append(items)
//                    DispatchQueue.main.async {
//                        collectionView.reloadData()
//                        self.rquestPage += self.nextPage
//                    }
//                }
//            }
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 2) && !isLoading {
            loadMoreData("\(self.rquestPage)", scrollView as? UICollectionView)
            rquestPage += 1
        }
    }
    
    func loadMoreData(_ page: String, _ collectionView: UICollectionView?) {
        if !self.isLoading {
            self.isLoading = true
            OpenMarketLoadData.requestOpenMarketMainPageData(page: page) { items in
                self.openMarketItemList.append(items)
            }
            
            DispatchQueue.main.async {
                collectionView?.reloadData()
                self.isLoading = false
            }
        }
    }
}
