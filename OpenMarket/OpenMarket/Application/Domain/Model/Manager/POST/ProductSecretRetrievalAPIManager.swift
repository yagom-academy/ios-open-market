//
//  ProductSecretRetrievalAPIManager.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

struct ProductSecretRetrievalAPIManager: POSTProtocol {
    var configuration: APIConfiguration
    var urlComponent: URLComponents
    
    init?(productID: Int) {
        urlComponent = URLComponentsBuilder()
            .setScheme("https")
            .setHost("market-training.yagom-academy.kr")
            .setPath("/api/products/\(productID)/secret")
            .build()
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        configuration = APIConfiguration(url: url)
    }
}
