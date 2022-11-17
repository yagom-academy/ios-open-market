//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let networkManager = NetworkManager()
        let healthCheckerRequest = HealthCheckerRequest()
        let productListRequest = ProductListRequest(pageNo: 1, itemsPerPage: 20)
        let detailRequest = ProductDetailRequest(productID: 183)
        
        guard let healthCheckerURL = healthCheckerRequest.url,
              let productListURL = productListRequest.url,
              let detailURL = detailRequest.url else { return }
        
        networkManager.fetchData(for: healthCheckerURL, dataType: String.self) { respone in
            switch respone {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        networkManager.fetchData(for: productListURL, dataType: ProductList.self) { respone in
            switch respone {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        networkManager.fetchData(for: detailURL, dataType: Product.self) { respone in
            switch respone {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

