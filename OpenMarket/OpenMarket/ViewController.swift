//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let testImage = UIImage(named: "test1")?.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            return
        }
        
//        let form = GoodsForm(title: "test-lasagna", descriptions: "desc", price: 100000000, currency: "KRW", stock: 1, discountedPrice: nil, images: [testImage], password: "1234")
//        Networking.registerGoods(form: form)
        
        let deleteForm = GoodsForm(id: 256, password: "1234")
        Networking.removeGoods(form: deleteForm)
    }
}

