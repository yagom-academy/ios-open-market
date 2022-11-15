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
        guard let healthCheckerURL = NetworkRequest.checkHealth.requestURL else {
            return
        }
        
        NetworkManager.shared.checkHealth(to: healthCheckerURL)
        
        guard let productDetailURL = NetworkRequest.productDetail.requestURL else {
            return
        }
        
        NetworkManager.shared.fetchData(to: productDetailURL, dataType: Product.self) { result in
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
        
        NetworkManager.shared.fetchData(to: productListURL, dataType: ProductPage.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
