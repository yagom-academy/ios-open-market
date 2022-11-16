//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let networkManager = NetworkManager()
        
        networkManager.getItemListData { ItemList in
            print(ItemList?.pageNo ?? 0)
        }
        
        networkManager.getItemData { Item in
            print(Item?.id ?? 0)
        }
    }


}

