//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var json = JsonParser()

    override func viewDidLoad() {
        super.viewDidLoad()
        testJsonParser()
    }
    
    func testJsonParser() {
        json.fetch()
    }
}

