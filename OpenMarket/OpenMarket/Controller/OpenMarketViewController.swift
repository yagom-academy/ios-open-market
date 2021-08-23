//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var products: [ItemData] = []
    private let networkManager = NetworkManager()
    private let cellIdentifier = "customCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.networkManager.commuteWithAPI(API: GetItemsAPI(page: 1)) { result in
            switch result {
            case .success(let data):
                guard let product = try? JsonDecoder.decodedJsonFromData(type: ItemsData.self, data: data) else {
                    return
                }
                self.products = product.items
            case .failure:
                print("jsonData is unDecodable")
            }
            self.collectionView.reloadData()
        }
    }
}
extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        let productForRow = products[indexPath.item]
        
        return cell
    }
    
    
}
