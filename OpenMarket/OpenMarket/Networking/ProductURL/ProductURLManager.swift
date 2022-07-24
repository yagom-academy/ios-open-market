//
//  ProductURLManager.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍.
//

import Foundation

struct ProductURLManager {
    func setUpProductListRetrieveQuery(pageNumber: Int, itemAmount: Int) -> URL? {
        let url = ProductURLRequest.baseURL.value
        
        guard var urlComponents = URLComponents(string: url) else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: ProductURLQueryItem.page_no.value, value: String(pageNumber)),
            URLQueryItem(name: ProductURLQueryItem.items_per_page.value, value: String(itemAmount))
        ]
        
        return urlComponents.url
    }
}
