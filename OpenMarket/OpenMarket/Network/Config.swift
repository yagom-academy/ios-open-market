//
//  Config.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

enum Config {
    static let baseUrl = "https://camp-open-market.herokuapp.com/"
    static let pathFormatWithParam = "%@/%u"
    static let pathFormatWithOutParam = "%@"
    
    static func setUpUrl(method: HttpMethod, path: UrlPath, param: UInt?) -> String {
        var urlString = ""
        var url = ""
        urlString.append(Config.baseUrl)
        
        switch method {
        case .get, .patch, .delete:
            urlString.append(Config.pathFormatWithParam)
            guard let param = param else {
                return ""
            }
            url = String(format: urlString, path.rawValue, param)
        case .post:
            urlString.append(Config.pathFormatWithOutParam)
            url = String(format: urlString, path.rawValue)
        }
        return url
    }
}
