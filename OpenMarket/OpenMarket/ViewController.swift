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
        
        networkManager.getProductsList(.searchProductList(pageNo: 1, itemsPerPage: 10)) { productList in
            print(productList)
        }
        
        networkManager.getHealthChecker(.healthChecker) { statusCode in
            print(statusCode)
        }
        
        networkManager.getProductDetail(.searchProductDetail(productNumber: 10)) { product in
            print(product)
        }
    }
}
