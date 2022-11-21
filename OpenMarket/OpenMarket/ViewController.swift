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
        
        networkManager.getHealthChecker { statusCode in
            print(statusCode)
        }
        
        networkManager.getProductDetail(productNumber: 10) { product in
            print(product)
        }
    }
}
