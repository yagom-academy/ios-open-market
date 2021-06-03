//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        var fetcher = ItemListFetcher()
        try? fetcher.fetchItemList { itemList in
            //code
            itemList?.itemList
        }
    }
}

