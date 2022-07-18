//
//  Item.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/15.
//

import UIKit

struct Item: Hashable {
    let productImage: UIImage
    let productName: String
    let price: String
    let bargainPrice: String
    let stock: String
    
    init(product: Product) {
        self.productName = product.name
        self.price = String(product.price)
        self.bargainPrice = String(product.bargainPrice)
        self.stock = String(product.stock)
        
        let sessionManager = URLSessionManager(session: URLSession.shared)
        var uiimage = UIImage()
        sessionManager.receiveData(baseURL: product.thumbnail) { result in
            switch result {
            case .success(let data):
                uiimage = UIImage(data: data) ?? UIImage.add
            case .failure(_):
                print("서버 데이터 불일치 오류")
            }
        }
        self.productImage = uiimage
    }
}
