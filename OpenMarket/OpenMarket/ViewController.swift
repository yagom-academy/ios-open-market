//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let netWorkHandler = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        netWorkHandler.requestHealthChecker()
        netWorkHandler.requestProductListSearching()
        netWorkHandler.requestDetailProductListSearching(32)
    }
}

