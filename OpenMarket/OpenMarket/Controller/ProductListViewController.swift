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
    private let parsingManager = ParsingManager()
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
            self.loadingIndicatorView.stopAnimating()
            switch result {
            case .success(let fetchedData):
                self.handleFetchedList(data: fetchedData)
            case .failure(let error):
                break
            }
        }
    }
    
    func handleFetchedList(data: Data) {
        let parsedResult = parsingManager.decode(from: data, to: Products.self)
        switch parsedResult {
        case .success(let products):
            let indexOffset = -1
            let startPoint = productList.count
            let endPoint = productList.count + products.items.count + indexOffset
    
            productList.append(contentsOf: products.items)
            reloadCollectionView(from: startPoint, to: endPoint)
            nextPageNumToBring += 1
        case .failure(let error):
            break
        }
    }
    
    func reloadCollectionView(from startPoint: Int, to endPoint: Int) {
        openMarketCollectionView.insertItems(at: [IndexPath(indexes: startPoint...endPoint)])
    }
    
}

extension ProductListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketItemCell", for: indexPath)
        guard let customCell = cell as? OpenMarketItemCell else {
            return cell
        }
        return customCell
    }
}

