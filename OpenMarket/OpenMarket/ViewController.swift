//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
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
        
//        FetchGoods().requestFetchGoods(id: 175) { result in
//            switch result {
//            case .success(let data):
//                debugPrint("👋:\(data)")
//            case .failure(let error):
//                debugPrint("❌:\(error.localizedDescription)")
//            }
//        }
        
        let deleteForm = DeleteForm(id: 325, password: "1234")
        DeleteGoods().requestDeleteGoods(params: deleteForm) { result in
            switch result {
            case .success(let data):
                debugPrint("👋:\(data)")
            case .failure(let error):
                debugPrint("❌:\(error.localizedDescription)")
            }
        }
    }
}

class DeleteForm: DeleteGoodsForm {
    var id: UInt
    var password: String
    
    func convertParameter() -> [String : Any] {
        let params: [String : Any] = [
            "id" : self.id,
            "password" : self.password
        ]
        return params
    }
    
    init(id: UInt, password: String) {
        self.id = id
        self.password = password
    }
}
