//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    let networkManager = NetworkManager(session: URLSession.shared)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = GetItemsAPI(page: 3)
        networkManager.commuteWithAPI(with: api) { result in
            if case .success(let data) = result {
                guard let product = try? JSONDecoder().decode(Items.self, from: data) else {
                    return
                }
                print(product)
            }
        }
        
        // Do any additional setup after loading the view.
    }
}

