//
//  OpenMarketDataSource.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

class OpenMarketDataSource: NSObject {
    
    //MARK: Property
    static var openMarketItemList = [OpenMarketItems]()
    private var isImageDownload = false
    
    override init() {
        super.init()
        
        OpenMarketLoadData.requestOpenMarketMainPageData(page: "1") { openMarketItems in
            OpenMarketDataSource.openMarketItemList = [openMarketItems]
        }
        
        //MARK: Stop initializing OpenMarketDataSource instance until get openMarketItemList
        while OpenMarketDataSource.openMarketItemList.count == 0 {
            continue
        }
    }
}

extension OpenMarketDataSource: UICollectionViewDataSource {
    //MARK: UICollectionViewDataSource Method
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        OpenMarketDataSource.openMarketItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        OpenMarketDataSource.openMarketItemList[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "openMarketCell", for: indexPath) as? OpenMarketItemCell else {
            return UICollectionViewCell()
        }
        
        //MARK: Cell's Item ID and Thubmnail Url
        let currentItem = Self.openMarketItemList[indexPath.section].items[indexPath.item]
        let urlString = currentItem.thumbnails.first
        let idNumber = currentItem.id
        
        //MARK: ImageLoader requests image
        let imageLoader = ImageLoader()
        let taskIdentifier = imageLoader.downloadImage(reqeustURL: urlString, imageCachingKey: idNumber) { downloadImage in
            DispatchQueue.main.async {
                if self.isImageDownload == false {
                    NotificationCenter.default.post(name: .imageDidDownload, object: nil)
                    self.isImageDownload = true
                }
                
                cell.configure(item: currentItem, thumnail: downloadImage)
                cell.isHidden = false
            }
        }
        
        //MARK: Cancel ImageLoader Request
        cell.onReuse = {
            if let taskIdentifier = taskIdentifier {
                imageLoader.cancelRequest(taskIdentifier)
            }
        }
        
        cell.isHidden = true
        
        return cell
    }
}
