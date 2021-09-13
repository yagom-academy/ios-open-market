//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    var productList = [Items]()
    var parsingManager = ParsingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIManager.shared.fetchProductList(page: 1) { result in
            switch result {
            case .success(let data):
                let resultData = try? self.parsingManager.decode(data, to: Items.self)
                self.productList.append(resultData!)
                print(self.productList.first?.page)
                
            case .failure(let error):
                
                print(error.localizedDescription)
            }
    }
}
}
