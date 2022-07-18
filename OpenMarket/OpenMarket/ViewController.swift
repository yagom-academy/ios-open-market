//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let address = NetworkNamespace.url.name
        let pageNo = URLQueryItem(name: NetworkNamespace.pageNo.name, value: "1")
        let itemsPerPage = URLQueryItem(name: NetworkNamespace.itemsPerPage.name, value: "10")
        let queryItems = [pageNo, itemsPerPage]
    }
}
