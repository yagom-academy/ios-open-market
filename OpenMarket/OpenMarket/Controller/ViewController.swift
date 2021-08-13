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
        let postItem = PostItemData(title: "핑구", descriptions: "귀여운 핑구", price: 100000000, currency: "won", stock: 1, password: "12345")
        
//        NetworkManager.init().getItems()
        NetworkManager.init().postItem(item: postItem)
    }
}

