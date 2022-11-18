//
//  URLComponents+Extension.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/15.
//

import Foundation

extension URLComponents {
    static func createURL(path: String?, queryItem: [URLQueryItem]?) -> URL? {
        var host = URLComponents(string: "https://openmarket.yagom-academy.kr")
        
        guard let path = path else {
            return host?.url
        }
        host?.path = path
        
        guard let queryItem = queryItem else {
            return host?.url
        }
        host?.queryItems = queryItem
        
        return host?.url
    }
}
