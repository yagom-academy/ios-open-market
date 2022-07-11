//
//  OpenMarket - ViewController.swift
//  Created by 케이, 수꿍. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = Bundle.main.path(forResource: "mock", ofType: "json") else {
            return
        }
        
        print(path)
    }


}

