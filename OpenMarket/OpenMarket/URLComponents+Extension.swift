//
//  .swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 15/11/2022.
//

import Foundation

extension URLComponents {
    static var healthCheckUrl: URL? {
        return URL(string: "https://openmarket.yagom-academy.kr/healthChecker")
    }
    
    static func marketUrl(path: [String]?, queryItems: [URLQueryItem]?) -> URL? {
        let baseUrl = "https://openmarket.yagom-academy.kr/api/products"
        var urlComponents = Self(string: baseUrl)
        
        if let path = path {
            _ = path.map { urlComponents?.path.append("/\($0)") }
        }
        
        if let queryItems = queryItems {
            urlComponents?.queryItems = queryItems
        }
        
        return urlComponents?.url
    }
}
