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
        
        guard let mediaImage = Media(image: #imageLiteral(resourceName: "맥북프로")), let mediaImage2 = Media(image: #imageLiteral(resourceName: "맥북프로")) else { return }
        var imageList: [Media] = [mediaImage, mediaImage2]
        
        let registProduct = RegistProductModel(title: "MacBook Air", descriptions: "좋아요", price: 100_000, currency: "KRW", stock: 5, discountedPrice: 80_000, password: "1234")
        let bodyParameter = registProduct.createProduct()
        
        APIManager.shared.registProduct(parameters: bodyParameter, media: imageList) { result in
            switch result {
            case .success(let data):
                print("성공스")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
//        APIManager.shared.fetchProductList(page: 1) { result in
//            switch result {
//            case .success(let data):
//                self.productList.append(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
     
        
    }
    
}

