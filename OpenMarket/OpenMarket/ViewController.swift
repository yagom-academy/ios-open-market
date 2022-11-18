//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkManager: NetworkManager = NetworkManager(session: URLSession(configuration: .default))
        
        networkManager.checkAPIHealth()
        print("OK")
        networkManager.fetchProductList(pageNumber: 1, itemsPerPage: 20)
        networkManager.fetchProductDetail(for: 98)
    }
}

