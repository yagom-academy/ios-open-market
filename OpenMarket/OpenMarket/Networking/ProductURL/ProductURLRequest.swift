//
//  ProductURLRequest.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

enum ProductURLRequest {
    case baseURL
    
    var value: String {
        switch self {
        case .baseURL:
            return "https://market-training.yagom-academy.kr/api/products"
        }
    }
}
