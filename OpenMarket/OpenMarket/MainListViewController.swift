//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainListViewController: UICollectionViewController {
    
    var productList = [ProductListSearch]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.fetchProductList(page: 1) { result in
            switch result {
            case .success(let data):
                self.productList.append(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

