//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.fetchData(to: NetworkURLAsset.productDetail,
                                        dataType: Product.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.description)
            }
        }
        
        NetworkManager.shared.fetchData(to: NetworkURLAsset.productList, dataType: ProductPage.self) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
