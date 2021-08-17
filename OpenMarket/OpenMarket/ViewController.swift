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
        var url = HttpInfo.deleteItem(id: 7)
        print(url.urlInfo.url,url.urlInfo.type)
    }


}

