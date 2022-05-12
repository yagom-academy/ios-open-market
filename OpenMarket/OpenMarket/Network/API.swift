//
//  API.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/12.
//

enum API: String {
    static let host = "https://market-training.yagom-academy.kr/"
    
    case healthChecker = "healthChecker"
    case catalog = "api/products"
    case product = "api/products/{{product_id}}"
    
    var path: String {
        self.rawValue
    }
}
