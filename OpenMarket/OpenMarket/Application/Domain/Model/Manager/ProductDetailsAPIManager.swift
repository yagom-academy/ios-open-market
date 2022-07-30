//
//  ProductDetailsAPIManager.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/30.
//

import Foundation

struct ProductDetailsAPIManager: APIProtocol {
    var configuration: APIConfiguration
    var urlComponents: URLComponents
    
    init?(productID: String) {
        urlComponents = URLComponentsBuilder()
            .setScheme("https")
            .setHost("market-training.yagom-academy.kr")
            .setPath("/api/products/\(productID)")
            .build()
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        configuration = APIConfiguration(method: .get,
                                         url: url)
    }
}
