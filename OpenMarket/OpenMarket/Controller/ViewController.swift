//
//  OpenMarket - ViewController.swift
//  Created by Kiwi, Hugh. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
let openMarketURLsession = OpenMarketURLSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        openMarketURLsession.getMethod(pageNumber: 1, itemsPerPage: 10) { result in
            switch result {
            case .success(let data):
                let safeData: ItemList? = JSONDecoder.decodeJson(jsonData: data!)
                dump(safeData)
            case .failure(.dataError):
                print("d")
            case .failure(.statusError):
                print("c")
            case .failure(.defaultError):
                print("a")
            }
        }
    }
}
