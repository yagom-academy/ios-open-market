//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
let openMarketURLsession = OpenMarketURLSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        openMarketURLsession.getMethod(url: "https://market-training.yagom-academy.kr/api/products") { listArray in
            guard let array = listArray else { return }
            dump(array)
        }
    }


}

