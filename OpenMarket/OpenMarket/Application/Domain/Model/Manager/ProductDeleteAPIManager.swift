//
//  ProductDeleteAPIManager.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/27.
//

import Foundation

struct ProductDeleteAPIManager: APIProtocol {
    var configuration: APIConfiguration
    var urlComponent: URLComponents
    
    init?(productId: Int, productSecret: String) {
        urlComponent = URLComponentsBuilder()
            .setScheme("https")
            .setHost("market-training.yagom-academy.kr")
            .setPath("/api/products/\(productId)/\(productSecret)")
            .build()
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        configuration = APIConfiguration(method: .delete,
                                         url: url)
    }
}
