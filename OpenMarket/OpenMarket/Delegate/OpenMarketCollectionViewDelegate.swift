//
//  OpenMarketCollectionViewDelegate.swift
//  OpenMarket
//
//  Created by Do Yi Lee on 2021/08/26.
//

import UIKit

class OpenMarketCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    //MARK: Private Property
    private var isLoading = false
    private var rquestPage: Int = 2
    private let nextPage = 1
}

extension OpenMarketCollectionViewDelegate {
    //MARK: Method
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
                OpenMarketDataSource.openMarketItemList.append(items)
            }
            
            DispatchQueue.main.async {
                collectionView?.reloadData()
                self.isLoading = false
            }
        }
    }
}
