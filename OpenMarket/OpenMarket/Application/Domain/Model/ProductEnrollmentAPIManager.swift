//
//  ProductEnrollmentAPIManager.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/27.
//

import Foundation

struct ProductEnrollmentAPIManager: APIProtocol {
    var configuration: APIConfiguration
    var urlComponent: URLComponents
    
    init?() {
        urlComponent = URLComponentsBuilder()
            .setScheme("https")
            .setHost("market-training.yagom-academy.kr")
            .setPath("/api/products")
            .build()
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        configuration = APIConfiguration(method: .post, url: url)
    }
}
