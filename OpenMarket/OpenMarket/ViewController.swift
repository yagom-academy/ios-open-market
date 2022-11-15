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
        
        networkManager.fetch(type: .searchProductList(1, 10)) { result in
            result.pages.forEach { product in
                print(product)
            }
        }
    }
}

