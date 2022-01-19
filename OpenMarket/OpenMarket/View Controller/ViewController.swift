//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var productCollectionView: UICollectionView!
    var productList: ProductList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        
        self.loadProductList()
    }
    
    func loadProductList() {
        getDecodedData { (result: Result<ProductList, NetworkError>) in
            switch result {
            case .success(let data):
                self.productList = data
                DispatchQueue.main.async {
                    self.productCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDecodedData(completionHandler: @escaping (Result<ProductList, NetworkError>) -> Void) {
        let decoder = Decoder()
        let urlSessionProvider = URLSessionProvider()
        
        urlSessionProvider.getData(requestType: .productList(pageNo: 1, items: 10)) { result in
            switch result {
            case .success(let data):
                guard let parsedData: ProductList = decoder.parsePageJSON(data: data) else {
                    return
                }
                
                completionHandler(.success(parsedData))
            case .failure(_):
                return completionHandler(.failure(NetworkError.unknownFailed))
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList?.productsInPage.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        guard let typeCastedCell = cell as? CollectionViewCell else {
            return cell
        }
        
        guard let productList = productList else {
            return typeCastedCell
        }
        
        guard let url = URL(string: productList.productsInPage[indexPath.item].thumbnail) else {
            return typeCastedCell
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                typeCastedCell.imageview.image = UIImage(data: data)
            }
        }
        
        typeCastedCell.productNameLabel.text = productList.productsInPage[indexPath.item].name
        typeCastedCell.bargainPriceLabel.text = String(productList.productsInPage[indexPath.item].bargainPrice)
        typeCastedCell.priceLabel.text = String(productList.productsInPage[indexPath.item].price)

        let stock = productList.productsInPage[indexPath.item].stock
        if stock == 0 {
            typeCastedCell.stockLabel.text = "품절"
        } else {
            typeCastedCell.stockLabel.text = "잔여수량: \(stock)"
        }
        
        return typeCastedCell
    }
}
