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
        openMarketURLsession.getMethod(pageNumber: 1, itemsPerPage: 10) { listArray in
            let itemData: ItemList? = JSONDecoder.decodeJson(jsonData: listArray!)
            dump(itemData)
        }
    }
}
