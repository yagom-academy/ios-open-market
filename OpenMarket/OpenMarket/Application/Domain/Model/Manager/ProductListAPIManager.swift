//
//  ProductListAPIManager.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/27.
//

import Foundation

struct ProductListAPIManager: APIProtocol {
    var configuration: APIConfiguration
    var urlComponents: URLComponents
    
    init?() {
        urlComponents = URLComponentsBuilder()
            .setScheme("https")
            .setHost("market-training.yagom-academy.kr")
            .setPath("/api/products")
            .addQuery(items: [ProductURLQueryItem.page_no.value: "1",
                              ProductURLQueryItem.items_per_page.value: "30"])
            .build()
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        configuration = APIConfiguration(method: .get,
                                         url: url)
    }
}
