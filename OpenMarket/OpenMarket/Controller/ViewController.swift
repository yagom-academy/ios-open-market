//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var networkCommunication = NetworkCommunication()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkCommunication.requestHealthChecker(url: "https://openmarket.yagom-academy.kr/healthChecker")
        networkCommunication.requestSearchListProducts(url: "https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=100")
        print(networkCommunication.searchListProducts)
    }


}
