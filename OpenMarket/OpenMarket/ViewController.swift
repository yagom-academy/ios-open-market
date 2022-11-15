//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getHealthChecker()
        NetworkManager.shared.getProductList()
        NetworkManager.shared.getProductDetail()
    }
    
    private func setupData() {
        let manager = DecodeManager<ProductPage>()
        let datas = manager.fetchData(name: "products")
        switch datas {
        case .success(let datas):
            let newData = datas.pages
            for item in newData {
                print(item)
            }
        case .failure(let error):
            print(error)
        }
    }
}
