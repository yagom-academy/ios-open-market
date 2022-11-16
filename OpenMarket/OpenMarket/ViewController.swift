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
        
        networkManager.fetch(type: .searchProductList(pageNo: 1, itemsPerPage: 10)) { result in
            if let result = result as? Int {
                print(result)
            } else if let result = result as? ProductsList {
                print(result)
            } else if let result = result as? Product {
                print(result)
            }
        }
    }
}
