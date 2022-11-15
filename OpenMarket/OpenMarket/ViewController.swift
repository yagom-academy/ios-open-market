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
        
        networkManager.fetch(type: .searchProductDetail(productNumber: 10)) { result in
            if let result = result as? Int { // 1. int일 경우
                print(result)
            } else if let result = result as? ProductsList { // 2. ProductsList
                print(result)
            } else if let result = result as? Product { // 3. Product
                print(result)
            }
        }
    }
}

