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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
        cell.configure(item: productForRow)
        return cell
    }
}

extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }

            var bounds = collectionView.bounds

            var width = bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
            var height = bounds.height - (layout.sectionInset.top + layout.sectionInset.bottom)

            width = (width - (layout.minimumInteritemSpacing * 1)) / 2
            height = (height - (layout.minimumLineSpacing * 2)) / 3

            return CGSize(width: width.rounded(.down), height: height.rounded(.down))
        }
}
