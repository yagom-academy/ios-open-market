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
        urlComponents?.path += "\(path.rawValue)"
        
        if method == .get || method == .delete || method == .patch {
            guard let param = param else {
                return nil
            }
            urlComponents?.path += "/\(String(param))"
        }

        return urlComponents?.url
    }
}
