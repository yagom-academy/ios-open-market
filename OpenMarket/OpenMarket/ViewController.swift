//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    func setupData() {
        let manager = DecodeManager<ProductPage>()
        guard let datas = try? manager.fetchData(name: "products") else { return }
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
