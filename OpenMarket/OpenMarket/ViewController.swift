//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let testImage = UIImage(named: "test1")?.jpegData(compressionQuality: 0.8) else {
            return
        }
        let form = GoodsForm(title: "test-lasagna", descriptions: "desc", price: 100000000, currency: "KRW", stock: 1, discountedPrice: nil, images: [testImage], password: "1234")
        guard let request = try? Networking.makeRequestWithGoodsForm(api: .registerGoods, with: form) else {
            return
        }
        try? Networking.requestToServer(with: request, dataType: Goods.self, completion: { result in
            switch result {
            case .success(let data):
                debugPrint("👋:\(data)")
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            }
        })
        
//        guard let request = try? Networking.makeRequest(api: .fetchGoodsList, with: 1) else {
//            return
//        }
//        try? Networking.requestToServer(with: request, dataType: MarketGoods.self, completion: { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋:\(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        })
    }
}

