//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let jsonParser = JSONParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProuctData()
    }
    
    func getProuctData() {
        jsonParser.fetch(by: URLCollection.productDetailInquery, completion: { (response) in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let data):
                print(data)
            }
        })
    }
}
