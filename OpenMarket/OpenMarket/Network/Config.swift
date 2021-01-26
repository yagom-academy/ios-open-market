//
//  Config.swift
//  OpenMarket
//
//  Created by Yeon on 2021/01/26.
//

import Foundation

enum Config {
    static let baseURL = "https://camp-open-market.herokuapp.com/"
    static let pathFormatWithParam = "%@/%u"
    static let pathFormatWithOutParam = "%@"
    
    static func setUpURL(method: Method, path: Path, param: UInt?) -> String {
        var urlString = ""
        var url = ""
        urlString.append(Config.baseURL)
        
        switch method {
        case .GET, .PATCH, .DELETE:
            urlString.append(Config.pathFormatWithParam)
            guard let param = param else {
                return ""
            }
            url = String(format: urlString, path.rawValue, param)
        case .POST:
            urlString.append(Config.pathFormatWithOutParam)
            url = String(format: urlString, path.rawValue)
        }
        return url
    }
}
