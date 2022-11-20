//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTestNetwork()
    }
    
    private func setupTestNetwork() {
        let networkManager = NetworkManager()
        guard let healthCheckerURL = NetworkRequest.checkHealth.requestURL else {
            return
        }
        
        networkManager.checkHealth(to: healthCheckerURL) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        
        guard let productDetailURL = NetworkRequest.productDetail.requestURL else {
            return
        }
        
        networkManager.fetchData(to: productDetailURL, dataType: Product.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.description)
            }
        }
        
        guard let productListURL = NetworkRequest.productList.requestURL else {
            return
        }
        
        networkManager.fetchData(to: productListURL, dataType: ProductPage.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
