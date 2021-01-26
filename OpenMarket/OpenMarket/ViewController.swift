//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let testImage = UIImage(named: "test1")?.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            return
        }
        
        let form = RegisterItemForm(title: "testtest", descriptions: "descdesc", price: 1, currency: "KRW", stock: 1, discountedPrice: 1, images: [testImage], password: "1234")
        Networking().registerGoods(form: form)
    }


}

