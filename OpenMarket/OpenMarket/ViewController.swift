//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        let fetcher = NetworkManager()
        try? fetcher.fetchItemList { itemList in
            print(itemList?.itemList)
        }
    }
}

