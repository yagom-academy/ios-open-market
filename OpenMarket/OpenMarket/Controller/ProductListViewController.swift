//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductListViewController: UIViewController {
    @IBOutlet private weak var openMarketCollectionView: UICollectionView!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    private var networkManger = NetworkManager()
    private var nextPageNumToBring = 1
    private var productList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openMarketCollectionView.dataSource = self
        openMarketCollectionView.register(UINib(nibName: "OpenMarketItemCell", bundle: nil), forCellWithReuseIdentifier: "OpenMarketItemCell")
        loadingIndicatorView.startAnimating()
        loadNextProductList(on: nextPageNumToBring)
    }

}

//MARK:- Fetch Product List
extension ProductListViewController {
    func loadNextProductList(on pageNum: Int) {
        networkManger.lookUpProductList(on: pageNum) { result in
            switch result {
            case .success(let fetchedData):
                let list = self.handleFetchedList(data: fetchedData).items
                self.productList.append(contentsOf: list)
                self.nextPageNumToBring += 1
            case .failure(let error):
                break
            }
        }
    }
    
    func handleFetchedList(data: Data) -> Products {
    }

}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketItemCell", for: indexPath)
        guard let customCell = cell as? OpenMarketItemCell else {
            return cell
        }
        return customCell
    }
}

