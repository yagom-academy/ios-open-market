//
//  NetworkConfig.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

enum NetworkConfig {
    static let baseUrl = "https://camp-open-market.herokuapp.com/"
    
    static func setUpUrl(method: HttpMethod, path: PathOfURL, param: UInt?) -> URL? {
        var urlComponents = URLComponents(string: baseUrl)
        
        switch method {
        case .get, .patch, .delete:
            guard let param = param else {
                return nil
            }
            urlComponents?.path += "\(path.rawValue)"
            urlComponents?.path += "/\(String(param))"
        case .post:
            urlComponents?.path += "\(path.rawValue)"
        }
        return urlComponents?.url
    }
}
