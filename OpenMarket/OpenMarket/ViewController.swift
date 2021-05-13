//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataManager = DataManager()
        dataManager.requestItemList(url: OpenMarketURL.viewItemList(1).url)
    }


}

