//
//  OpenMarket - ViewController.swift
//  Created by Zhilly, Dragon. 22/11/14
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var NM = NetworkManager()
    var productList = JSONDecoder.decodeAsset(name: "test", to: ProductList.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NM.getItemList(pageNumber: 1, itemPerPage: 100) { result in
            switch result {
            case .success(let data):
                let test = JSONDecoder.decodeData(data: data, to: ProductList.self)
            case .failure(_):
                print("fail")
                break
            }
        }
    }
}

