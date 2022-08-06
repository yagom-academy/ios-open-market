//
//  ProductListAPIManager.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import Foundation

struct ProductListAPIManager: GETProtocol {
    var configuration: APIConfiguration
    var urlComponents: URLComponents
    
    init?(pageNumber: Int) {
        urlComponents = URLComponentsBuilder()
            .setScheme("https")
            .setHost("market-training.yagom-academy.kr")
            .setPath("/api/products")
            .addQuery(items: [ProductURLQueryItem.page_no.value: "\(pageNumber)",
                              ProductURLQueryItem.items_per_page.value: "\(20)"])
            .build()
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        configuration = APIConfiguration(url: url)
    }
}
