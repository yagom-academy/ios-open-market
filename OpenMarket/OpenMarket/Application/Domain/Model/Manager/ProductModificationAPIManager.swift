//
//  ProductModificationAPIManager.swift
//  OpenMarket
//
//  Created by Derrick kim on 2022/07/27.
//

import Foundation

struct ProductModificationAPIManager: APIProtocol {
    var configuration: APIConfiguration
    var urlComponent: URLComponents
    
    init?(productID: Int) {
        urlComponent = URLComponentsBuilder()
            .setScheme("https")
            .setHost("market-training.yagom-academy.kr")
            .setPath("/api/products/\(productID)")
            .build()
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        configuration = APIConfiguration(method: .patch,
                                         url: url)
    }
}
