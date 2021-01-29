//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FetchMarketGoodsList().requestFetchMarketGoodsList(page: 1) { result in
            switch result {
            case .success(let data):
                debugPrint("👋:\(data)")
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            }
        }
    }
}

