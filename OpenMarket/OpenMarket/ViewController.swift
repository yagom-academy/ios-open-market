//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let jsonParser = JsonParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParser.fetch(from: jsonParser.url)
    }
    
}

