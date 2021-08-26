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
        
        let currentItem = Self.openMarketItemList[indexPath.section].items[indexPath.item]
        
        let urlString = currentItem.thumbnails.first
        let idNumber = currentItem.id
        
//        if let cachedImage = ImageCacher.shared.pullImage(forkey: idNumber) {
//            cell.configure(item: currentItem, thumnail: cachedImage)
//        } else {
            downloadImage(reqeustURL: urlString, imageCachingKey: idNumber) { image in
                DispatchQueue.main.async {
                    cell.configure(item: currentItem, thumnail: image)
                    if self.isImageDownload == false {
                        NotificationCenter.default.post(name: .imageDidDownload, object: nil)
                        self.isImageDownload = true
                    }
                }
            }
       //}
        return cell
    }
    
    func downloadImage(reqeustURL: String?, imageCachingKey: Int, _ completionHandler: @escaping (UIImage) -> ()) {
        guard let urlString = reqeustURL, let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            guard let downloadImage = UIImage(data: data) else { return }
            
            //ImageCacher.shared.save(downloadImage, forkey: imageCachingKey)
            
            completionHandler(downloadImage)
        }
        
        task.resume()
    }
    
}
