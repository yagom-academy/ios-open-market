//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        let network = NetworkManager()
        
        let images = [
            Photo(withImage: UIImage(named: "MackBookImage_0")!)!,
            Photo(withImage: UIImage(named: "MackBookImage_1")!)!
        ]
        let post = PostAPI.registrateProduct(title: "asdf", contentType: .multiPartForm, descriptions: "asdf", price: 1, currency: "asdf", stock: 1, discountedPrice: nil, mediaFile: images , password: "asdf")
        
        network.request(apiModel: post) { (result) in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

