//
//  OpenMarketDataSource.swift
//  OpenMarket
//
//  Created by KimJaeYoun on 2021/08/20.
//

import UIKit

class OpenMarketDataSource: NSObject, UICollectionViewDataSource {
    override init() {
        super.init()
        let loadData = OpenMarketLoadData(networkManager: NetworkManager(session: .shared))
        loadData.requestOpenMarketMainPageData(page: "1") { testData in
            self.openMarketItemList = [testData]
        }
        
        while self.openMarketItemList.count == 0 {
            continue
        }
    }
    
    var openMarketItemList = [OpenMarketItems]()
    
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
        cell.isHidden = true
        let imageArray = openMarketItemList[indexPath.section].items[indexPath.item].thumbnails
        let reqeustUrl = imageArray[0]
        URLSession.shared.dataTask(with: URL(string: reqeustUrl)!) { data, error, _ in
            if let error = error {
                dump(error)
            }
            
            guard let data = data else { return }
            let result = UIImage(data: data)
            DispatchQueue.main.async {
                cell.configure(item: self.openMarketItemList[indexPath.section].items[indexPath.item], image: result!)
                cell.isHidden = false
            }
        }.resume()
        return cell
    }
}
