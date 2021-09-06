//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    var productList = [Items]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        APIManager.shared.fetchProductList(page: 1) { result in
//            switch result {
//            case .success(let data):
//                self.productList.append(data)
//                print(self.productList)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
        guard let mediaImage = Media(image: #imageLiteral(resourceName: "iPad8")), let mediaImage2 = Media(image: #imageLiteral(resourceName: "iPad8")) else { return }
        var imageList: [Media] = [mediaImage, mediaImage2]

        let registProduct = RegistProductModel(title: "iPad", descriptions: "좋아요", price: 100_000, currency: "KRW", stock: 5, discountedPrice: 80_000, password: "1234")
        let bodyParameter = registProduct.createProduct()

        APIManager.shared.registProduct(parameters: bodyParameter, media: imageList) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
