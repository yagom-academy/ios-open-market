//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var testImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        FetchMarketGoodsList().requestFetchMarketGoodsList(page: 1) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋:\(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
        
        FetchGoods().requestFetchGoods(id: 1) { result in
            switch result {
            case .success(let data):
                debugPrint("👋:\(data)")
                guard let decoded = data as? Goods,
                      let images = decoded.images,
                      let first = images.first else {
                    return
                }
                
                FetchImage().getResource(url: first) { result in
                    switch result {
                    case .failure(let error):
                        debugPrint("❌:\(error.localizedDescription)")
                    case .success(let data):
                        if let imageData = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.testImage.image = imageData
                            }
                        }
                    }
                }
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            }
        }
//        
//        let deleteForm = DeleteForm(id: 343, password: "1234")
//        DeleteGoods().requestDeleteGoods(params: deleteForm) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋:\(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
        
//        guard let testImage = UIImage(named: "test1")?.jpegData(compressionQuality: 0.8) else {
//            return
//        }
//        let registerForm = RegisterForm(title: "lasagna-joons", descriptions: "lasagna-joons", price: 100000000, currency: "KRW", stock: 1, discountedPrice: 10000, images: [testImage], password: "1234")
//        RegisterGoods().requestRegisterGoods(params: registerForm) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋:\(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
//
//        let editForm = EditForm(title: "lasagna-joons22", descriptions: nil, price: nil, currency: nil, stock: nil, discountedPrice: nil, images: nil, id: 340, password: "1234")
//        EditGoods().requestEditGoods(params: editForm) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋:\(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
    }
}
